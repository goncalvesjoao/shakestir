# ShakeStir React

React and TypeScript frontend for ShakeStir, using React Router, TanStack Query, Vitest, and Playwright. It connects to the FastAPI backend. The ingredient catalog and ingredient images work; the other API-backed workflows remain in the frontend while their Python endpoints are being built and will currently fail with 404 responses.

The build uses Vite 7.3 and the standard React plugin, without React Compiler. CSS processing uses PostCSS and the default esbuild minifier; Lightning CSS is not installed. Vite stays on the supported 7.3 line to keep that dependency optional.

## Run locally

See the [root README](../README.md) for prerequisites. Start the backend in one terminal, from the repository root:

```sh
cd shakestir-fastapi
uv sync --locked --extra dev
cp .env.example .env
uv run db-setup
uv run dev
```

In another terminal, from the repository root:

```sh
cd shakestir-react
npm ci
cp .env.example .env
npm run dev
```

Copy environment files only on first setup; preserve existing settings. Open <http://localhost:5173/ingredients> (or the port printed by Vite). The catalog displays seeded names, descriptions, and available photos, and supports local name filtering. Recipe links lead to workflows awaiting backend support. The default homepage is also an unfinished recipe workflow.

The frontend proxies `/api/*` to `http://127.0.0.1:8000`, stripping `/api`. Default environment values:

```dotenv
VITE_API_BASE_URL=/api
VITE_BACKEND_URL=http://127.0.0.1:8000
API_PROXY_TARGET=http://127.0.0.1:8000
```

`API_PROXY_TARGET` controls the development proxy target. `VITE_BACKEND_URL` identifies absolute image URLs that should be mapped through that proxy; it should match the backend's generated URL origin. Restart Vite after environment changes. No cross-origin browser configuration is needed for the default same-origin proxy.

## Verification

```sh
npm run build
npm run lint
npm test
# Requires the seeded Python backend at :8000 and Vite at :5173.
npx playwright install chromium
npx playwright test e2e/ingredients.spec.ts
```

The remaining browser workflows in `e2e/workflows.spec.ts` require endpoints FastAPI does not implement yet. `npm run test:e2e` includes those tests and is not expected to pass until backend coverage expands. Unit tests use mocked API responses and do not establish backend support for those workflows.

Screenshots and browser reports are ignored generated artifacts. See [API implementation status](ROUTE_PARITY.md).

## Deployment

Serve React deep links and proxy `/api/*` to FastAPI with the prefix removed. Configure backend image URL generation and `VITE_BACKEND_URL` consistently with your public proxy. Vite's development proxy is not included in the production build or `vite preview`.

The hero image and ingredient illustrations are original AI-generated transparent PNGs; prompts and provenance are recorded in `../db/seeds/demo/image_prompts.json`. Google Fonts has local system fallbacks.
