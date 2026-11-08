"""Migrate and seed without resetting existing data."""

from scripts.db.migrate import migrate
from scripts.db.seed.ingredients import run_seed


def main() -> None:
    migrate()
    run_seed()


if __name__ == "__main__":
    main()
