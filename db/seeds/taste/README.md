# Synthetic taste fixtures

Taste values are embedded in `../demo/recipes.json` and `../demo_accounts.json`. They are deliberate UI fixtures on a 0–5 scale for sweetness, sourness and bitterness, not source-provided scores or sensory tasting results. Notebook system recipes have no estimates so the UI can distinguish unknown values from explicit zeroes.

Each spec includes a SHA-256 fingerprint over its ordered ingredient identities, submitted text, quantities, units, optionality, roles, preparation notes and ordered preparation steps. The prototype fills missing taste fields only when the author, source identity and exact spec still match. Existing zeroes, curation and modified or reassigned recipes are preserved. FastAPI does not yet implement recipes or taste filtering.
