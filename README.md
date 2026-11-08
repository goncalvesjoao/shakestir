# ShakeStir

ShakeStir helps people discover, create, and organize cocktail recipes, including finding drinks they can make with their available ingredients and tools. It is a recipe marketplace with no buying or selling.

The Rails application is the working prototype and behavioral reference. Development is moving toward a React frontend and a Python backend, reproducing the prototype's workflows and adding new functionality.

## Current implementation

| Project | Role | Current state |
| --- | --- | --- |
| [`shakestir-fastapi/`](shakestir-fastapi/README.md) | Python backend using FastAPI, SQLAlchemy, and Alembic | Public ingredient catalog and image delivery, used by React; other prototype workflows are not implemented yet. |
| [`shakestir-react/`](shakestir-react/README.md) | React and TypeScript frontend | Uses FastAPI for the ingredient catalog; other API-backed workflows await Python endpoints. |
| [`shakestir-rails/`](shakestir-rails/README.md) | Rails prototype | Working behavioral reference, independent of the React–Python setup. |
| `shakestir-nextjs/` (planned) | Future Next.js project | Will be added to the monorepo; not available yet. |
| `shakestir-vuejs/` (planned) | Future Vue.js project | Will be added to the monorepo; not available yet. |
| [`db/seeds/`](db/seeds/README.md) | Shared offline seed data and images | Keep this directory alongside the application directories; Python resolves its default seed files here. |

**React now connects to FastAPI.** The ingredient catalog at `/ingredients` works with the Python backend, including available images and local name filtering. Other API-backed pages remain unfinished: the frontend retains their requests, but FastAPI does not implement those endpoints yet.

## Prerequisites

- Git.
- Python 3.11 or newer. The Python project pins 3.11 in `.python-version`.
- [uv](https://docs.astral.sh/uv/getting-started/installation/) installed and available in your terminal (`uv --version`). It runs the Python backend. Root snapshot and seed-generation scripts use `python3` directly.
- Node.js 24.15 or newer in the 24.x release line, or Node.js 26+, with npm. These versions satisfy the current frontend development dependencies.
- Ruby is not required for React or FastAPI. To run the separate prototype, follow the [Rails setup instructions](shakestir-rails/README.md#local-development).

Clone the repository and enter its root:

```sh
git clone https://github.com/goncalvesjoao/shakestir.git
cd shakestir
```

The commands below start from this directory unless stated otherwise. Initial dependency installation requires internet access; the checked-in seed data can be loaded offline afterward.

## Set up the Python backend

In one terminal:

```sh
npm run fastapi:setup
npm run fastapi:dev
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

For later schema or seed updates, run these from the repository root:

```sh
npm run fastapi:db:migrate
npm run fastapi:db:seed
```

## Set up the React frontend

In another terminal, starting from the repository root:

```sh
npm run react:setup
npm run react:dev
```

As with Python, preserve an existing `.env`. Open <http://localhost:5173/ingredients>, using the port Vite prints. This is the currently supported API-backed page; the default recipe homepage awaits backend implementation.

The default settings are:

```dotenv
VITE_API_BASE_URL=/api
VITE_BACKEND_URL=http://127.0.0.1:8000
API_PROXY_TARGET=http://127.0.0.1:8000
```

The Vite development proxy forwards `/api/*` to FastAPI with the prefix removed. `API_PROXY_TARGET` controls its target; `VITE_BACKEND_URL` identifies backend-generated media URLs to rewrite through the proxy. Restart Vite after environment changes. No prototype server is required.

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

## Demo content

The shared [demo dataset](db/seeds/demo/README.md) contains original fictional recipes and generated transparent images. It includes 30 cocktail families, a parent/variant relationship, 120 system recipes, five author recipes, 15 ingredients, tools, techniques, ordered steps, mentions and public/private collections. FastAPI currently loads only the ingredient catalog; the remaining entities are fixtures for the prototype and future Python endpoints.

Run `npm run seed-build` to rebuild the JSON deterministically without network access. Images are checked in separately; their exact prompts and provenance are recorded in the dataset. Taste and ABV values are illustrative fixtures, not tested sensory results or branded product specifications.

Seeding preserves existing content. To avoid mixing previously imported data with the new fixtures, use a fresh local database and storage directory. Do not reset a database containing work you need to keep.

## Example data and credentials

The repository intentionally includes synthetic development and test values:

- `db/seeds/system_account.json` and `db/seeds/demo_accounts.json` contain fictional accounts at `shakestir@shakestir.example`, `leo@shakestir.example`, and `alex@shakestir.example`, all with the dummy password `password`. Profile names, biographies, and avatars are fictional.
- `shakestir-react/e2e/workflows.spec.ts` creates temporary QA users with addresses such as `react-qa-<timestamp>@example.com` and the dummy password `Reviewable!Password9`. Mock API responses use `test` as a dummy CSRF token.
- The Python and React `.env.example` files contain local database/storage paths and localhost service URLs, with no real service credentials. Source references under `https://shakestir.example/` are fictional fixture identifiers.

These values are examples, not credentials for real external accounts or personal contact information. Use them only in local development or isolated tests, and never reuse the dummy passwords for real accounts. Source snapshots retain these documented fixtures and example environment files while excluding actual `.env` files and runtime databases. If an upload requires disclosure of retained dummy values, identify them yourself and review any scan warnings before submission.

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

The build checks TypeScript and creates `dist/`. Unit tests use mocked APIs. The ingredient browser test requires a seeded FastAPI server at port 8000, Vite at port 5173, and Playwright Chromium:

```sh
npx playwright install chromium
npx playwright test e2e/ingredients.spec.ts
```

Other browser workflow tests cover endpoints not yet implemented by FastAPI and are not expected to pass.

## Common setup issues

| Symptom | Check |
| --- | --- |
| Python reports a missing table | Run `uv run db-migrate` from `shakestir-fastapi/`, then `uv run db-seed`. |
| Python cannot find its seed catalog | Preserve the repository layout, including `db/seeds/` beside `shakestir-fastapi/`. |
| React loads but requests fail | Confirm FastAPI is running at port 8000. Only ingredient listing and images are supported so far. |
| `/ingredients.json` returns 404 on FastAPI | The Python endpoint is `/ingredients`; use that path. |
| npm reports an unsupported Node version | Use a Node version listed in the prerequisites, then rerun `npm ci`. |
| Browser tests cannot connect | Start FastAPI and Vite, seed the Python database, and run the ingredient browser test. |

## Create a source snapshot

From the repository root, run:

```sh
npm run snapshot
```

Requires Git, npm, and Python 3.11+ available as `python3`. The npm script runs the Python utility directly using only the standard library; no root Python package or virtual environment is needed. This writes a ZIP and a companion file-list manifest to the ignored `snapshots/` directory. It packages the current Python and React source, shared seeds, snapshot tooling, and selected root documents. Both tracked files and nonignored new files are included, using current working contents rather than the last commit.

The archive uses [`scripts/snapshot/README.md`](scripts/snapshot/README.md) as its root README, with setup instructions scoped to the included Python and React projects. The full monorepo README and `PRODUCT.md` implementation record are not copied. The manifest records this README source mapping.

The snapshot excludes the prototype, historical reports, design documents, agent tooling, Git history, dependencies, build output, caches, local environment files, and runtime data. Example environment files and dependency lockfiles are retained. Repository structure is preserved so shared seed paths still work. Source and ZIP sizes must each stay below 100 MB.

For a custom destination:

```sh
npm run snapshot -- --output snapshots/shakestir-review.zip
```

Existing outputs are never overwritten. Review the manifest and extracted contents before uploading; this command does not establish that all data or third-party assets are permitted for submission and does not upload anything. Running the snapshot command itself requires a Git checkout; the extracted snapshot can run the applications without Git history.

## Further reading

- [Product vision](PRODUCT_VISION.md): discovery rules, recipe concepts, content preservation, and proposed entity matching, moved from the original root README.
- [Product record](PRODUCT.md): users, product direction, and prototype implementation evidence.
- [Domain glossary](GLOSSARY.md).
- [Shared seed data](db/seeds/README.md).
- [React API contracts and route parity](shakestir-react/ROUTE_PARITY.md).
- [FastAPI implementation and configuration](shakestir-fastapi/README.md).
- [React development and deployment](shakestir-react/README.md).

## Licensing

ShakeStir's original application code and demo content use the [MIT license](LICENSE). Dependencies retain their own licenses; see the [third-party license inventory](THIRD_PARTY_LICENSES.md) for runtime, development and locked transitive packages, plus fonts and asset provenance.

The frontend uses supported Vite 7.3 with the standard React plugin and no React Compiler configuration. Lightning CSS is not installed or resolved as a package in the lockfile; Vite lists it only as an optional peer. Installed dependencies and compiled distributions must retain the upstream licenses and notices applicable to what they redistribute. The inventory documents the active Python/React projects; the separate Rails prototype has its own dependencies.
