import itertools

import pytest
from sqlalchemy.orm import Session

from shakestir.models import Ingredient


def create_ingredient(session: Session, **attributes) -> Ingredient:
    ingredient = Ingredient(**attributes)
    session.add(ingredient)
    session.commit()
    session.refresh(ingredient)
    return ingredient


@pytest.fixture()
def ingredient_factory(test_session):
    counter = itertools.count(1)

    def _create_ingredient(**attributes) -> Ingredient:
        attributes.setdefault("name", f"Ingredient {next(counter)}")
        return create_ingredient(test_session, **attributes)

    return _create_ingredient
