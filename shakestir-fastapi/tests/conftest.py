from pathlib import Path

import pytest
from alembic import command
from alembic.config import Config
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from shakestir.app import app
from shakestir.db import create_database_engine, get_session
from shakestir.settings import settings

pytest_plugins = ["support.factories"]


@pytest.fixture()
def migration_config(tmp_path, monkeypatch):
    monkeypatch.setattr(settings, "storage_path", tmp_path / "storage")
    monkeypatch.setattr(settings, "database_url", f"sqlite:///{tmp_path / 'test.db'}")
    return Config(str(Path(__file__).resolve().parents[1] / "alembic.ini"))


@pytest.fixture()
def test_engine(migration_config):
    command.upgrade(migration_config, "head")
    engine = create_database_engine()
    try:
        yield engine
    finally:
        engine.dispose()


@pytest.fixture()
def test_session(test_engine):
    with Session(test_engine) as session:
        yield session


@pytest.fixture()
def test_app(test_engine):
    def get_test_session():
        with Session(test_engine) as session:
            yield session

    previous_overrides = app.dependency_overrides.copy()
    app.dependency_overrides[get_session] = get_test_session
    try:
        yield app
    finally:
        app.dependency_overrides.clear()
        app.dependency_overrides.update(previous_overrides)


@pytest.fixture()
def test_client(test_app):
    with TestClient(test_app) as client:
        yield client
