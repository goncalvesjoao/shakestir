# ShakeStir Python and React

ShakeStir helps people discover, create, and organize cocktail recipes. This source snapshot contains a React and TypeScript frontend, a Python backend, and original shared demo data.

**The ingredient catalog is the currently working API-backed flow.** Open `/ingredients` in React to browse, filter, and view ingredient images from FastAPI. Recipe discovery, authentication, collections, profiles, and authoring screens remain in the frontend, but their Python endpoints are not implemented yet. Those requests currently return 404; the default recipe homepage is one of these unfinished screens.

## Included projects

| Directory | Purpose |
| --- | --- |
| [`shakestir-fastapi/`](shakestir-fastapi/README.md) | FastAPI, SQLAlchemy, and Alembic backend; public ingredient listing and image delivery. |
| [`shakestir-react/`](shakestir-react/README.md) | React frontend connected to FastAPI through a development proxy. |
| [`db/seeds/`](db/seeds/README.md) | Original offline demo JSON and generated images. Keep this directory alongside the application directories. |
| `scripts/` | Offline fixture generator and source snapshot utilities. |

## Prerequisites

- Python 3.11 or newer. The Python project pins 3.11 in `.python-version`.
- [uv](https://docs.astral.sh/uv/getting-started/installation/) installed and available in your terminal (`uv --version`). It runs the Python backend. Root snapshot and seed-generation scripts use `python3` directly.
- Node.js 24.15 or newer in the 24.x release line, or Node.js 26+, with npm.

Extract the archive and open a terminal in its root, where this README and both application directories are located. Git is not required to run the applications. Initial dependency installation needs internet access; database setup and seeding use checked-in files afterward.

## Start the Python backend

From the extracted root, in one terminal:

```sh
npm run fastapi:setup
npm run fastapi:dev
```

Copy the example environment file only on first setup; preserve an existing `.env`. Defaults require no external database service or API credentials:

- SQLite database: `shakestir-fastapi/data/shakestir.db`.
- Local image storage: `shakestir-fastapi/data/storage/`.

Set `DATABASE_URL` and `STORAGE_PATH` in `.env` to override these paths. `db-setup` applies migrations and seeds ingredients without resetting existing data. Reruns preserve curated fields and images.

The API runs at <http://127.0.0.1:8000>. Check it with:

```sh
curl http://127.0.0.1:8000/ingredients
```

The response contains `data` and `metadata.total_count`; image URLs are present when stored images exist. Interactive API documentation is at <http://127.0.0.1:8000/docs>.

## Start the React frontend

From the extracted root, in another terminal:

```sh
npm run react:setup
npm run react:dev
```

Preserve an existing `.env`. Open **<http://localhost:5173/ingredients>**, using the port Vite prints if it differs.

The default environment settings are:

```dotenv
VITE_API_BASE_URL=/api
VITE_BACKEND_URL=http://127.0.0.1:8000
API_PROXY_TARGET=http://127.0.0.1:8000
```

Vite forwards `/api/*` to FastAPI and removes the prefix. `API_PROXY_TARGET` controls that server target. `VITE_BACKEND_URL` identifies backend-generated image URLs to map through the proxy. Restart Vite after changing environment settings.

The frontend uses Vite 7.3 and the standard React plugin without React Compiler. CSS processing uses PostCSS and the default esbuild minifier; Lightning CSS is not installed.

## Root command shortcuts

Run these from the repository root; the scripts enter the appropriate project directory automatically. `npm run setup` installs both projects, copies missing `.env` files without replacing existing settings, and migrates and seeds the FastAPI database. Then start `npm run fastapi:dev` and `npm run react:dev` in separate terminals. No root npm dependencies need installing.

| Command | Purpose |
| --- | --- |
| `npm run fastapi:setup` / `npm run react:setup` | Set up one project |
| `npm run fastapi:dev` / `npm run react:dev` | Start each development server |
| `npm run fastapi:start` | Start FastAPI without reload |
| `npm run fastapi:db:setup` | Migrate and seed the database |
| `npm run fastapi:db:migrate` / `npm run fastapi:db:seed` | Run database tasks separately |
| `npm run check` | Check Python lint/format and React lint/build |
| `npm test` | Run Python and React unit tests |
| `npm run build` | Build React |
| `npm run react:preview` | Preview the React build |

Checks and tests also have individual `fastapi:check`, `react:check`, `fastapi:test`, and `react:test` shortcuts. Run `npm run` to list all commands. Existing commands within each project remain available. Setup scripts use a POSIX shell (macOS, Linux, or WSL).

## Demo data and unfinished models

The [original demo dataset](db/seeds/demo/README.md) has six fictional cocktail families, 24 system recipes, five author recipes, 15 ingredients, tools, techniques, ordered steps, mentions, and public/private collections. It includes a parent/variant relationship, shared ingredients, structured quantities, optional garnishes, and unknown versus explicit zero taste values.

**FastAPI currently loads only ingredients and their images.** The other JSON files describe related fixture data for future model and endpoint work; their presence does not mean the corresponding backend features are implemented. Taste and ABV values are illustrative fixtures, not measured results or branded product specifications. Images are generated illustrations of plausible servings.

From the extracted root, rebuild the JSON without downloading anything:

```sh
npm run seed-build
```

This does not regenerate the checked-in images. Run `uv run db-seed` from `shakestir-fastapi/` to apply ingredient seed changes after migrations. Use a fresh database and storage directory for a clean demo; do not reset data you need to keep.

## Example data and credentials

The snapshot deliberately retains fictional development and test values:

- `db/seeds/system_account.json` and `db/seeds/demo_accounts.json` contain `shakestir@shakestir.example`, `leo@shakestir.example`, and `alex@shakestir.example` with the dummy password `password`. Names, biographies, and avatars are fictional; these JSON accounts are not loaded by the current Python backend.
- Browser workflow tests use temporary `react-qa-<timestamp>@example.com` users and the dummy password `Reviewable!Password9`. Mock API responses use the dummy CSRF token `test`.
- `.env.example` files contain local paths and localhost URLs, not real service credentials. Source URLs under `https://shakestir.example/` are fictional fixture identifiers.

Use these values only in local development or isolated tests. Never reuse the dummy passwords for real accounts. If an upload requires disclosure of retained dummy values, identify them yourself and review any scan warnings before submission.

## Run the checks

From `shakestir-fastapi/`:

```sh
uv run pytest
uv run ruff check .
uv run ruff format --check .
```

Python tests migrate temporary SQLite databases and do not require a running server.

From `shakestir-react/`:

```sh
npm run build
npm run lint
npm test
```

Unit tests use mocked APIs. With FastAPI seeded and running at port 8000 and Vite running at port 5173, run the supported browser integration test:

```sh
npx playwright install chromium
npx playwright test e2e/ingredients.spec.ts
```

`e2e/workflows.spec.ts` covers broader application flows whose endpoints are not implemented yet. Consequently, the full `npm run test:e2e` suite is not expected to pass at this stage.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Missing database table | Run `uv run db-migrate`, then `uv run db-seed` from `shakestir-fastapi/`. |
| Missing seed catalog | Keep `db/seeds/` alongside `shakestir-fastapi/`; do not copy only the application directory. |
| Ingredient page cannot connect | Confirm FastAPI is running at port 8000 and Vite's proxy target matches it. |
| Other pages return 404 from the API | Their endpoints are not implemented; see [API implementation status](shakestir-react/ROUTE_PARITY.md). |
| Unsupported Node version | Use a version listed in the prerequisites and rerun `npm ci`. |

## Licensing and scope

Original application code and demo content use the [MIT license](LICENSE). Dependencies retain their own licenses; the [third-party inventory](THIRD_PARTY_LICENSES.md) covers the Python/React dependency sets, fonts, and asset provenance.

This archive excludes other implementations, installed dependencies, build output, runtime data, local `.env` files, historical reports, and agent tooling. Snapshot utilities are included for reference; `npm run snapshot` requires a full Git checkout and is not needed to run this extracted project.

See the [product vision](PRODUCT_VISION.md) for intended behavior and the [glossary](GLOSSARY.md) for domain terminology. They describe product direction, not a claim that every feature is implemented.
