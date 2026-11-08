from alembic import command
from sqlalchemy import inspect


def test_migration_round_trip(test_engine, migration_config):
    engine, config = test_engine, migration_config
    command.check(config)
    assert "ingredients" in inspect(engine).get_table_names()
    command.downgrade(config, "base")
    assert "ingredients" not in inspect(engine).get_table_names()
    command.upgrade(config, "head")
    assert "ingredients" in inspect(engine).get_table_names()
