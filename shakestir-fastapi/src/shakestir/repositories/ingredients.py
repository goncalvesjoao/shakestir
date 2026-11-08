from sqlalchemy import select
from sqlalchemy.orm import Session

from shakestir.models import Ingredient


def find_all(session: Session) -> list[Ingredient]:
    records = session.scalars(
        select(Ingredient).where(Ingredient.normalized_name.is_not(None))
    ).all()
    return sorted(
        (record for record in records if record.name and record.name.strip()),
        key=lambda record: (record.name.lower(), record.id),
    )
