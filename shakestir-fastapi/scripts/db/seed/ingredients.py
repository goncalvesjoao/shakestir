"""Load the shared, offline ingredient catalog without overwriting curation."""

import argparse
import hashlib
import json
import logging
import re
from dataclasses import dataclass
from decimal import Decimal, InvalidOperation
from pathlib import Path

from sqlalchemy import select
from sqlalchemy.orm import Session

from shakestir.db import engine
from shakestir.models import Ingredient
from shakestir.models.ingredient import normalize_name
from shakestir.storage import image_path, store_image

DEFAULT_SEED_FILE = (
    Path(__file__).resolve().parents[4] / "db/seeds/demo/ingredients.json"
)

# Match specific ingredient categories before general ones in the shared catalog.
CATEGORY_PATTERNS = (
    ("ice", r"^ice$"),
    ("spirit", r"spirit|rum|gin|vodka|whiskey|bourbon|brandy|tequila|mezcal|cognac"),
    ("liqueur", r"liqueur|amaro|cordial|triple sec|apercitif"),
    ("wine", r"wine|vermouth|sherry|champagne"),
    ("beer", r"beer"),
    ("juice", r"juice|soda|citrus|acid"),
    ("syrup", r"syrup|sweetener|grenadine"),
    ("fruit", r"fruit|herb|fresh|vegetable"),
    ("dairy", r"milk|cream|dairy"),
    ("herb", r"herb|mint|basil|cilantro"),
    ("spice", r"spice|bitters"),
    ("mixer", r"mixer|water|tonic|soda|club soda|ginger beer|cola"),
)


@dataclass
class SeedResult:
    created: int = 0
    updated: int = 0
    skipped: int = 0


def normalize_category(value: str | None) -> str:
    for category, pattern in CATEGORY_PATTERNS:
        if re.search(pattern, (value or "").lower()):
            return category
    return "other"


def parse_abv(value: str | None) -> Decimal | None:
    if value is None or not str(value).strip():
        return None
    try:
        abv = Decimal(str(value).strip())
    except InvalidOperation as error:
        raise ValueError(f"Invalid seed ABV: {value!r}") from error
    if not abv.is_finite() or not 0 <= abv <= 100:
        raise ValueError(f"Seed ABV must be between 0 and 100: {value!r}")
    return abv


def normalize_alcohol_status(value: str | None, abv: Decimal | None) -> str:
    value = (value or "").strip().lower()
    if value in {"no", "non alcoholic", "non-alcoholic", "non_alcoholic"}:
        return "non_alcoholic"
    if value in {"yes", "alcoholic"}:
        return "alcoholic"
    if abv is not None:
        return "alcoholic" if abv > 0 else "non_alcoholic"
    return "unknown"


def attach_seed_image(ingredient: Ingredient, name: str, image_dir: Path) -> bool:
    if ingredient.image_key and image_path(ingredient.image_key).is_file():
        return False
    slug = re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")
    candidates = [
        image_dir / f"{slug}{extension}"
        for extension in (".png", ".jpg", ".jpeg", ".webp")
    ]
    source = next((path for path in candidates if path.is_file()), None)
    if source is None:
        logging.getLogger(__name__).warning("Missing cached ingredient image: %s", name)
        return False
    # Restore missing files only when they match the existing attachment identity.
    if ingredient.image_key:
        digest = hashlib.sha256(source.read_bytes()).hexdigest()
        if ingredient.image_key != f"ingredients/{digest}{source.suffix.lower()}":
            logging.getLogger(__name__).warning(
                "Preserving missing nonmatching image: %s", name
            )
            return False
        store_image(source)
        return False
    ingredient.image_key = store_image(source)
    return True


def seed_ingredients(
    session: Session, seed_file: Path = DEFAULT_SEED_FILE
) -> SeedResult:
    """Flush changes; the caller owns the transaction and commit."""
    data = json.loads(seed_file.read_text(encoding="utf-8"))
    rows = data["ingredients"]
    if not isinstance(rows, list):
        raise TypeError("Seed ingredients must be a list")
    result = SeedResult()
    seen = set()
    for row in rows:
        name = (row.get("name") or "").strip()
        normalized = normalize_name(name)
        if not normalized or normalized in seen:
            result.skipped += 1
            continue
        seen.add(normalized)
        abv = parse_abv(row.get("abv"))
        attributes = {
            "description": row.get("description") or None,
            "category": normalize_category(row.get("type")),
            "alcohol_status": normalize_alcohol_status(row.get("alcohol"), abv),
            "alcohol_by_volume": abv,
        }
        ingredient = session.scalars(
            select(Ingredient)
            .where(Ingredient.normalized_name == normalized)
            .order_by(Ingredient.id)
        ).first()
        if ingredient is None:
            ingredient = Ingredient(name=name, **attributes)
            attach_seed_image(ingredient, name, seed_file.parent / "images/ingredients")
            session.add(ingredient)
            result.created += 1
        else:
            changed = False
            for field, value in attributes.items():
                current = getattr(ingredient, field)
                missing = current is None or (
                    isinstance(current, str) and not current.strip()
                )
                missing |= field == "category" and current == "other"
                missing |= field == "alcohol_status" and current == "unknown"
                if missing and value is not None and current != value:
                    setattr(ingredient, field, value)
                    changed = True
            changed |= attach_seed_image(
                ingredient, name, seed_file.parent / "images/ingredients"
            )
            if changed:
                result.updated += 1
            else:
                result.skipped += 1
    session.flush()
    return result


def run_seed(seed_file: Path = DEFAULT_SEED_FILE) -> None:
    with Session(engine) as session, session.begin():
        result = seed_ingredients(session, seed_file)
    print(
        f"Ingredients: {result.created} created, "
        f"{result.updated} updated, {result.skipped} skipped."
    )


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Seed the ingredient catalog after migrations."
    )
    parser.add_argument(
        "--file", type=Path, default=DEFAULT_SEED_FILE, help="Ingredient JSON file"
    )
    args = parser.parse_args()
    run_seed(args.file)


if __name__ == "__main__":
    main()
