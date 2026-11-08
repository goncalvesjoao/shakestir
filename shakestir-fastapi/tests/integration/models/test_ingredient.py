import pytest
from sqlalchemy.exc import IntegrityError

from shakestir.models import Ingredient


def test_name_normalization(test_session):
    session = test_session
    ingredient = Ingredient(name="  ＧＩＮ\t  Soda  ")
    session.add(ingredient)
    session.commit()
    assert ingredient.normalized_name == "gin soda"
    ingredient.name = "  RUM "
    session.commit()
    assert ingredient.normalized_name == "rum"


@pytest.mark.parametrize(
    "values",
    [
        {"category": "invalid"},
        {"alcohol_status": "invalid"},
        {"alcohol_by_volume": -1},
        {"alcohol_by_volume": 101},
    ],
)
def test_database_constraints(test_session, values):
    session = test_session
    session.add(Ingredient(name="Gin", **values))
    with pytest.raises(IntegrityError):
        session.commit()


def test_blank_name_rejected(test_session):
    session = test_session
    session.add(Ingredient(name="  \t"))
    with pytest.raises(ValueError, match="must not be blank"):
        session.commit()
