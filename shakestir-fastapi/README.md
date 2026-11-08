# ShakeStir FastAPI

A standalone backend implementation in the ShakeStir monorepo. Inspired by the backend of `fastAPI-vuejs-scaffold`: FastAPI, SQLAlchemy, Pydantic Settings, a `src/` package, session dependencies, and router/repository separation. Alembic manages the schema; the app never creates tables automatically.

## Run locally

From the repository root, you can also use `npm run fastapi:setup` followed by `npm run fastapi:dev`. Setup preserves existing `.env` files. See the [root command shortcuts](../README.md#root-command-shortcuts) for checks and other tasks.

Requires Python 3.11+ and [uv](https://docs.astral.sh/uv/).

```sh
cd shakestir-fastapi
uv sync --extra dev
cp .env.example .env
uv run db-setup
uv run dev
```

The default database is a separate SQLite file at `shakestir-fastapi/data/shakestir.db`, resolved relative to the project regardless of the working directory. `DATABASE_URL` overrides it. The setup script migrates and seeds the shared ingredient catalog.

```sh
curl http://localhost:8000/ingredients
# Returns the seeded ingredient catalog.
```

`GET /ingredients` requires no authentication. Results contain `id`, `name`, `description`, and `image_url`, sorted by lowercase name and then ID. Interactive documentation is available at `/docs`.

## Ingredient model

The model and initial migration define the ingredient fields: name, description, normalized name, category (default `other`), alcohol status (default `unknown`), decimal ABV, and timestamps. Category/status enums and the inclusive 0–100 ABV range are enforced by database checks. Normalized names are indexed, but not unique. ORM inserts and updates require a nonblank name and apply Unicode NFKC, lowercase, and whitespace normalization. Names retain their submitted spelling.

Ingredient images are imported from the shared cache during seeding and copied to local storage at `data/storage/` (ignored by Git). `STORAGE_PATH` overrides this directory; relative paths resolve against `shakestir-fastapi/`. Keep this directory on a persistent volume when deploying and back it up alongside the database.

Each ingredient stores an `image_key`, with files named by their SHA-256 hash. `GET /ingredients/{ingredient_id}/image` serves the public image with its media type and standard file response headers. The catalog returns an absolute `image_url` when the file exists, otherwise `null`; missing images return 404. Configure proxy headers appropriately if deploying behind a proxy. There is no upload endpoint or image resizing yet.

Seed reruns preserve existing images and only restore missing files when the cached bytes match their stored key. Missing source images are logged and do not block catalog import. The current catalog contains 15 original demo ingredients, each with an AI-generated transparent image. Database changes are transactional; copied files can remain unreferenced if a seed transaction fails, and later reruns reuse them. Recipe/step associations remain outside this implementation.

## Seeds and project commands

Run these commands from `shakestir-fastapi/`:

| Command | Purpose |
| --- | --- |
| `uv run dev` | Start the API with reload at localhost:8000 |
| `uv run start` | Start the API on 0.0.0.0:8000 without reload |
| `uv run db-migrate` | Apply all Alembic migrations |
| `uv run db-seed` | Seed ingredients into an already migrated database |
| `uv run db-setup` | Migrate, then seed; never resets the database |

All shortcuts are project entry points in `pyproject.toml`, backed by code in `scripts/` outside the runtime package. `dev` and `start` run Uvicorn; database commands use the modules in `scripts/db/`.

The ingredient loader reads `../db/seeds/demo/ingredients.json` offline, resolved from the project directory rather than the working directory. It matches normalized names, skips blank names and duplicate identities, creates missing ingredients, and fills missing descriptions, category (`other`), alcohol status (`unknown`), and ABV. Existing names, curated values, IDs, and timestamps on unchanged records are preserved. A failed import rolls back the entire seed transaction.

The ingredient loader imports descriptions and decimal ABV and recognizes the source's `Yes`/`No` alcohol flags. It does not require a cached image to import an ingredient; ingredients without an image still appear with `image_url: null`. The original fixture format uses `name`, `description`, `type`, `alcohol` and `abv`; there are no external source IDs.

For an alternate catalog with the same JSON format:

```sh
uv run db-seed --file /absolute/path/to/ingredients.json
```

The source file must be present when running seeds; shared seed assets are not bundled in the Python wheel. Migrations remain separate from seed data.

## Development

```sh
uv run pytest
uv run ruff check .
uv run ruff format --check .
uv run alembic revision --autogenerate -m "Describe schema change"
uv run alembic upgrade head
uv run alembic downgrade -1
```

Tests migrate temporary SQLite databases and cover the public contract, ordering, normalization, database constraints, schema drift, and migration rollback/reapply.

```text
src/shakestir/
  app.py              # FastAPI application
  settings.py         # Environment configuration
  db.py               # Engine and request session lifecycle
  dependencies.py     # Typed FastAPI dependencies
  models/             # SQLAlchemy table models and declarative base
  schemas/            # Pydantic response schemas
  repositories/       # Catalog queries
  routers/api/        # HTTP endpoint
scripts/
  dev.py              # Development server shortcut
  start.py            # Server without reload
  db/
    migrate.py        # Apply migrations
    setup.py          # Migrate and seed
    seed/ingredients.py # Shared catalog importer
migrations/           # Alembic environment and revisions
tests/
  conftest.py         # Shared engine, session, app, and client fixtures
  support/            # Reusable factories (pytest plugins)
  integration/
    test_db.py        # Migration checks
    models/           # Model persistence and constraints
    routes/api/       # Endpoint tests grouped by resource
```
