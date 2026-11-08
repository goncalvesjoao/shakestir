# Frontend API implementation status

React uses FastAPI through the same-origin `/api` proxy. The Python backend currently supports only the public ingredient catalog and its images.

| Frontend route | API contract | Status |
| --- | --- | --- |
| `/ingredients` | `GET /ingredients` returns `{data, metadata: {total_count}}` | Supported; name filtering is performed in the browser. |
| Ingredient photos | `GET /ingredients/{id}/image` | Supported; absolute backend image URLs are rewritten through `/api`. |
| Discovery, recipes, cocktails, utensils, techniques | Existing `.json` requests in the frontend | Not implemented by FastAPI; requests return 404. |
| Sessions, registration, recovery, profiles, collections and authoring | Existing `.json` requests in the frontend | Not implemented by FastAPI; requests return 404. |
| `/mixing` | Browser session storage | Local queue remains available; loading new recipes requires future backend support. |

The frontend retains unfinished workflows as the backend grows. Their existing request shapes are not a promise that FastAPI implements them. Authentication and CSRF handling in those workflows are also pending backend integration. No compatibility endpoints or synthetic success responses are provided.

The development proxy defaults to `http://127.0.0.1:8000`. Set `API_PROXY_TARGET` to override the server target and `VITE_BACKEND_URL` to match the origin used in backend-generated image URLs. `VITE_API_BASE_URL` defaults to `/api`. Production hosting must provide its own same-origin API proxy; Vite preview does not include the development proxy.
