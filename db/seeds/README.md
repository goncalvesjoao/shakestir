# Seed data

Shared offline fixtures and original images live here. The [original demo dataset](demo/README.md) describes the fictional cocktail families, ingredients, recipes and relationship coverage. The repository's MIT license covers this demo content; no external cocktail database is bundled.

From `shakestir-fastapi/`, run `uv run db-setup` to migrate and seed the 15-ingredient catalog, or `uv run db-seed` after migrations. Its loader reads `demo/ingredients.json` and copies the generated transparent ingredient images into local storage. The Python implementation does not yet seed recipes, users, tools or collections.

From `shakestir-rails/`, run `bin/rails db:seed` to load the complete graph: system and fictional author accounts, six cocktail families, 29 recipes, tools, techniques, ordered steps, mentions and collections. All required data and images are checked in; seeding requires no network calls or image-generation credentials.

The [taste notes](taste/README.md), [technique catalog](techniques/README.md), [utensil catalog](utensils/README.md), and [fictional avatars](avatars/README.md) document their scope and provenance. Dummy credentials and `.example` addresses are development fixtures only.

Reruns preserve existing records, curation, assigned authors and uploaded images. Missing stored seed files are restored only when their bytes match the existing image identity. Seeding does not remove data from earlier datasets; use a fresh local database/storage pair for a clean demo.
