import json
from decimal import Decimal

import pytest
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from scripts.db.seed.ingredients import DEFAULT_SEED_FILE, seed_ingredients
from shakestir.models import Ingredient


def write_seed(tmp_path, rows):
    path = tmp_path / "ingredients.json"
    path.write_text(json.dumps({"ingredients": rows}))
    return path


def test_shared_catalog_and_rerun(test_session, test_client):
    expected_names = {
        row["name"].strip()
        for row in json.loads(DEFAULT_SEED_FILE.read_text())["ingredients"]
    }
    first = seed_ingredients(test_session)
    test_session.commit()
    assert first.created == len(expected_names)
    ingredients = test_session.scalars(select(Ingredient)).all()
    before = {row.id: row.updated_at for row in ingredients}
    assert {row.name for row in ingredients} == expected_names
    gin = next(row for row in ingredients if row.name == "Gin")
    assert gin.category == "spirit"
    assert gin.alcohol_status == "alcoholic"
    assert gin.alcohol_by_volume == Decimal("40.00")
    assert {row.name: row.category for row in ingredients} == {
        row["name"]: row["type"]
        for row in json.loads(DEFAULT_SEED_FILE.read_text())["ingredients"]
    }
    assert gin.description
    second = seed_ingredients(test_session)
    test_session.commit()
    assert second.created == second.updated == 0
    assert second.skipped == len(expected_names)
    assert {
        row.id: row.updated_at for row in test_session.scalars(select(Ingredient))
    } == before
    response = test_client.get("/ingredients")
    assert response.status_code == 200
    assert response.json()["metadata"]["total_count"] == len(expected_names)


def test_fills_missing_fields_and_preserves_curation(
    test_session, ingredient_factory, tmp_path
):
    curated = ingredient_factory(
        name="GIN",
        description="Curated",
        category="liqueur",
        alcohol_status="non_alcoholic",
        alcohol_by_volume=0,
    )
    missing = ingredient_factory(name="Rum")
    path = write_seed(
        tmp_path,
        [
            {
                "name": "Gin",
                "description": "Imported",
                "type": "Gin",
                "alcohol": "Yes",
                "abv": "40",
            },
            {
                "name": "Rum",
                "description": "Imported",
                "type": "Rum",
                "alcohol": "Yes",
                "abv": "40",
            },
        ],
    )
    result = seed_ingredients(test_session, path)
    test_session.commit()
    assert result.created == 0
    assert result.updated == 1
    test_session.refresh(curated)
    test_session.refresh(missing)
    assert (
        curated.name,
        curated.description,
        curated.category,
        curated.alcohol_status,
        curated.alcohol_by_volume,
    ) == ("GIN", "Curated", "liqueur", "non_alcoholic", Decimal(0))
    assert (
        missing.description,
        missing.category,
        missing.alcohol_status,
        missing.alcohol_by_volume,
    ) == ("Imported", "spirit", "alcoholic", Decimal(40))


def test_normalized_duplicates_and_blank_names(test_session, tmp_path):
    path = write_seed(
        tmp_path,
        [
            {"name": "  ＧＩＮ "},
            {"name": "gin"},
            {"name": "  "},
            {"name": None},
        ],
    )
    result = seed_ingredients(test_session, path)
    test_session.commit()
    assert result.created == 1
    assert result.skipped == 3
    assert test_session.scalar(select(func.count()).select_from(Ingredient)) == 1


def test_non_alcoholic_source_flag(test_session, tmp_path):
    path = write_seed(tmp_path, [{"name": "Juice", "alcohol": "No", "type": "Juice"}])
    seed_ingredients(test_session, path)
    ingredient = test_session.scalars(select(Ingredient)).one()
    assert ingredient.alcohol_status == "non_alcoholic"
    assert ingredient.alcohol_by_volume is None


@pytest.mark.parametrize("abv", ["bad", "NaN", "Infinity", "-1", "101"])
def test_failure_rolls_back_entire_import(test_engine, tmp_path, abv):
    path = write_seed(
        tmp_path,
        [
            {"name": "Gin", "abv": "40"},
            {"name": "Invalid", "abv": abv},
        ],
    )
    with Session(test_engine) as session, pytest.raises(ValueError), session.begin():
        seed_ingredients(session, path)
    with Session(test_engine) as session:
        assert session.scalar(select(func.count()).select_from(Ingredient)) == 0


def test_ice_is_a_non_alcoholic_ingredient(test_session, tmp_path):
    path = write_seed(
        tmp_path, [{"name": "Ice", "type": "ice", "alcohol": "No", "abv": "0"}]
    )
    seed_ingredients(test_session, path)
    ice = test_session.scalars(select(Ingredient)).one()
    assert ice.category == "ice"
    assert ice.alcohol_status == "non_alcoholic"
    assert ice.alcohol_by_volume == 0
