# Original ShakeStir demo data

These fictional formulations, names, descriptions and background notes were created for ShakeStir UI development. They do not reproduce an external recipe database. All ABV and taste values are illustrative fixtures rather than product specifications or measured tasting results. Demo content is provided under the repository's MIT license.

## Files and relationships

- `ingredients.json`: 15 canonical ingredients, including spirits, nonalcoholic mixers, mint and ice. Names retain their spelling; the loaders normalize identities separately.
- `cocktails.json`: six fictional canonical families. Frozen Lantern is a child of Citrus Lantern. Background text explicitly describes fictional origins.
- `recipes.json`: four preparations per family, with stable IDs, structured ingredient quantities, optional garnish lines, required tools, ordered steps, techniques, taste values and spec fingerprints. Notebook variants leave taste unknown; Notebook Garden Spark omits gin for a nonalcoholic example.
- `../demo_accounts.json`: two fictional authors, three public recipes, two private drafts, and public/private collections containing recipes from multiple authors.
- `images/`: original AI-generated transparent PNGs for all ingredients and cocktail families. Recipe variations share their family's illustration; optional garnishes are illustrative styling, not additional required ingredients.
- `image_prompts.json`: the exact image generation prompts, tool and output assignments. Images were generated from text without third-party image references. They are illustrations of plausible servings, not photographs of tested recipes.

The system account and demo passwords are dummy development credentials. All account email addresses and source URLs use reserved `.example` domains. They are not real people, contact addresses, live accounts or external references.

## Rebuild and seed

Run `python3 scripts/build_demo_data.py` from the repository root to deterministically rebuild the JSON. This does not download or regenerate image files. The checked-in images are required for offline setup.

FastAPI reads only `ingredients.json` and `images/ingredients/`; it does not implement the remaining domain models yet. From `shakestir-fastapi/`, run `uv run db-setup`. Existing ingredient names and curated fields/images are preserved on reruns.

The prototype loads the complete relationship graph with `bin/rails db:seed` from its project directory. It attaches independent photos to canonical cocktails and their recipes, and links example mentions in preparation steps to canonical ingredients/tools. Reruns preserve curation, reassigned recipes and uploaded photos. Existing databases can still contain previously imported content: seeding is additive and does not erase old records or overwrite nonblank descriptions/images. Use a fresh local database and storage directory to see only this dataset; never reset a database containing work you need to keep.
