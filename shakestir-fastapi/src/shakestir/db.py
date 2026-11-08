from collections.abc import Generator
from pathlib import Path

from sqlalchemy import create_engine
from sqlalchemy.engine import make_url
from sqlalchemy.orm import Session

from shakestir.settings import settings


def create_database_engine():
    url = make_url(settings.normalized_database_url())
    is_sqlite = url.drivername.startswith("sqlite")
    if is_sqlite and url.database not in (None, "", ":memory:"):
        Path(url.database).parent.mkdir(parents=True, exist_ok=True)
    return create_engine(
        url, connect_args={"check_same_thread": False} if is_sqlite else {}
    )


engine = create_database_engine()


def get_session() -> Generator[Session, None, None]:
    with Session(engine) as session:
        yield session
