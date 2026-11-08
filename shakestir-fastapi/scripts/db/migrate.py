"""Apply pending schema migrations."""

from pathlib import Path

from alembic import command
from alembic.config import Config


def migrate() -> None:
    project_dir = Path(__file__).resolve().parents[2]
    command.upgrade(Config(str(project_dir / "alembic.ini")), "head")


if __name__ == "__main__":
    migrate()
