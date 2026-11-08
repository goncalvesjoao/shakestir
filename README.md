# ShakeStir

ShakeStir helps people discover, create, and organize cocktail recipes, including finding drinks they can make with their available ingredients and tools. It is a recipe marketplace with no buying or selling.

The Rails application is the working prototype and behavioral reference. Development is moving toward a React frontend and a Python backend, reproducing the prototype's workflows and adding new functionality.

## Current implementation

| Project | Role | Current state |
| --- | --- | --- |
| [`shakestir-fastapi/`](shakestir-fastapi/README.md) | Python backend using FastAPI, SQLAlchemy, and Alembic | Standalone public ingredient catalog and image delivery; other prototype workflows are not implemented yet. |
| [`shakestir-react/`](shakestir-react/README.md) | React and TypeScript frontend | Implements discovery and account/recipe workflows against the Rails API. |
| [`shakestir-rails/`](shakestir-rails/README.md) | Rails prototype and current frontend backend | Provides the API that React currently uses. |
| `shakestir-nextjs/` (planned) | Future Next.js project | Will be added to the monorepo; not available yet. |
| `shakestir-vuejs/` (planned) | Future Vue.js project | Will be added to the monorepo; not available yet. |
| [`db/seeds/`](db/seeds/README.md) | Shared offline seed data and images | Keep this directory alongside the application directories; Python resolves its default seed files here. |

**React is not connected to FastAPI yet.** Starting both projects does not produce a complete application: React currently proxies `/api` to Rails at `http://localhost:3000`. FastAPI runs independently at `http://127.0.0.1:8000` and exposes `/ingredients` and `/ingredients/{ingredient_id}/image`. React expects additional endpoints, including `/ingredients.json`, `/recipes.json`, and `/session.json`; changing the proxy port alone is insufficient.

## Prerequisites

- Git.
- Python 3.11 or newer and [uv](https://docs.astral.sh/uv/getting-started/installation/). The Python project pins 3.11 in `.python-version`.
- Node.js 24.15 or newer in the 24.x release line, or Node.js 26+, with npm. These versions satisfy the current frontend development dependencies.
- Ruby and the Rails dependencies only if you want to exercise the frontend's API-backed workflows. See the [Rails setup instructions](shakestir-rails/README.md#local-development).

Clone the repository and enter its root:

```sh
git clone https://github.com/goncalvesjoao/shakestir.git
cd shakestir
```

The commands below start from this directory unless stated otherwise. Initial dependency installation requires internet access; the checked-in seed data can be loaded offline afterward.

## Set up the Python backend

In one terminal:

```sh
cd shakestir-fastapi
uv sync --locked --extra dev
cp .env.example .env
uv run db-setup
uv run dev
```

Copy the example environment file only on first setup; keep an existing `.env` if you have already configured it. Defaults use SQLite and local image storage, with no external database service or API credentials required.

`db-setup` applies Alembic migrations and seeds the ingredient catalog without resetting the database. The defaults are:

- Database: `shakestir-fastapi/data/shakestir.db`.
- Images: `shakestir-fastapi/data/storage/`.

Both paths are local runtime data ignored by Git. Set `DATABASE_URL` and `STORAGE_PATH` in `.env` to override them. Python storage and database files are independent of Rails.

With the server running, open:

- API documentation: <http://127.0.0.1:8000/docs>.
- Ingredient catalog: <http://127.0.0.1:8000/ingredients>.

Or check it from another terminal:

```sh
curl http://127.0.0.1:8000/ingredients
```

The catalog response contains `data` and `metadata.total_count`. Ingredients without a cached image have `image_url: null`.

For later schema or seed updates, run these from `shakestir-fastapi/`:

```sh
uv run db-migrate
uv run db-seed
```

## Set up the React frontend

In another terminal, starting from the repository root:

```sh
cd shakestir-react
npm ci
cp .env.example .env
npm run dev
```

As with Python, preserve an existing `.env`. Open the URL Vite prints, normally <http://localhost:5173>.

The default settings are:

```dotenv
VITE_API_BASE_URL=/api
VITE_BACKEND_URL=http://localhost:3000
```

The Vite development proxy forwards `/api/*` to Rails with the prefix removed. `VITE_BACKEND_URL` helps rewrite media URLs; it does not change the proxy target. Restart Vite after changing environment settings.

To use the frontend's current discovery, authentication, recipe, and collection workflows, also start the Rails backend in a third terminal. From the repository root, after installing the Rails prerequisites:

```sh
cd shakestir-rails
mise exec -- ruby bin/setup --skip-server
mise exec -- ruby bin/rails server
```

Rails runs at <http://localhost:3000>. Follow its [README](shakestir-rails/README.md) for database, seed, and system dependency details. FastAPI can run alongside it, but currently does not serve React's workflows.

## Run the checks

Python, from `shakestir-fastapi/`:

```sh
uv run pytest
uv run ruff check .
uv run ruff format --check .
```

Python tests migrate temporary SQLite databases; they do not require a running server or the Rails database.

React, from `shakestir-react/`:

```sh
npm run build
npm run lint
npm test
```

The build checks TypeScript and creates `dist/`. Unit tests do not require Rails. Browser tests require a seeded Rails server at port 3000, Vite at port 5173, and Playwright Chromium:

```sh
npx playwright install chromium
npm run test:e2e
```

## Common setup issues

| Symptom | Check |
| --- | --- |
| Python reports a missing table | Run `uv run db-migrate` from `shakestir-fastapi/`, then `uv run db-seed`. |
| Python cannot find its seed catalog | Preserve the repository layout, including `db/seeds/` beside `shakestir-fastapi/`. |
| React loads but requests fail | Confirm Rails is running at port 3000. FastAPI does not yet implement React's API contract. |
| `/ingredients.json` returns 404 on FastAPI | The Python endpoint is `/ingredients`; the `.json` route belongs to Rails. |
| npm reports an unsupported Node version | Use a Node version listed in the prerequisites, then rerun `npm ci`. |
| Browser tests cannot connect | Start both Rails and Vite and seed the Rails database; these tests do not use FastAPI. |

## Further reading

- [Product vision](PRODUCT_VISION.md): discovery rules, recipe concepts, content preservation, and proposed entity matching, moved from the original root README.
- [Product record](PRODUCT.md): users, product direction, and prototype implementation evidence.
- [Domain glossary](GLOSSARY.md).
- [Shared seed data](db/seeds/README.md).
- [React API contracts and route parity](shakestir-react/ROUTE_PARITY.md).
- [FastAPI implementation and configuration](shakestir-fastapi/README.md).
- [React development and deployment](shakestir-react/README.md).

The repository is [MIT licensed](LICENSE). Seed source notes and asset provenance are documented in the seed directories.
