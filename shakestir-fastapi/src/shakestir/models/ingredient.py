import unicodedata
from datetime import UTC, datetime
from decimal import Decimal
from enum import Enum

from sqlalchemy import CheckConstraint, DateTime, Numeric, String, Text, event
from sqlalchemy.orm import Mapped, mapped_column

from shakestir.models.base import Base


class IngredientCategory(str, Enum):
    spirit = "spirit"
    liqueur = "liqueur"
    wine = "wine"
    beer = "beer"
    mixer = "mixer"
    juice = "juice"
    syrup = "syrup"
    fruit = "fruit"
    dairy = "dairy"
    herb = "herb"
    spice = "spice"
    ice = "ice"
    other = "other"


class AlcoholStatus(str, Enum):
    alcoholic = "alcoholic"
    non_alcoholic = "non_alcoholic"
    unknown = "unknown"


def utc_now() -> datetime:
    return datetime.now(UTC)


def normalize_name(name: str) -> str:
    return " ".join(unicodedata.normalize("NFKC", name).lower().split())


class Ingredient(Base):
    __tablename__ = "ingredients"
    __table_args__ = (
        CheckConstraint(
            "category IN ('spirit','liqueur','wine','beer','mixer','juice','syrup','fruit','dairy','herb','spice','ice','other')",
            name="ingredients_category",
        ),
        CheckConstraint(
            "alcohol_status IN ('alcoholic','non_alcoholic','unknown')",
            name="ingredients_alcohol_status",
        ),
        CheckConstraint(
            "alcohol_by_volume IS NULL OR (alcohol_by_volume >= 0 AND alcohol_by_volume <= 100)",
            name="ingredients_alcohol_by_volume_range",
        ),
    )

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str | None] = mapped_column(String)
    description: Mapped[str | None] = mapped_column(Text)
    image_key: Mapped[str | None] = mapped_column(String)
    normalized_name: Mapped[str | None] = mapped_column(String, index=True)
    category: Mapped[IngredientCategory] = mapped_column(
        String, nullable=False, default=IngredientCategory.other, server_default="other"
    )
    alcohol_status: Mapped[AlcoholStatus] = mapped_column(
        String, nullable=False, default=AlcoholStatus.unknown, server_default="unknown"
    )
    alcohol_by_volume: Mapped[Decimal | None] = mapped_column(Numeric(5, 2))
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=utc_now
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=utc_now, onupdate=utc_now
    )


@event.listens_for(Ingredient, "before_insert")
@event.listens_for(Ingredient, "before_update")
def set_normalized_name(mapper, connection, ingredient: Ingredient) -> None:
    ingredient.normalized_name = (
        normalize_name(ingredient.name) if ingredient.name else None
    )
    if not ingredient.normalized_name:
        raise ValueError("Ingredient name must not be blank")
