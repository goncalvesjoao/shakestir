"""Validate the shared fixture graph even before all entities exist in FastAPI."""

import json

from sqlalchemy import select

from scripts.db.seed.ingredients import DEFAULT_SEED_FILE, seed_ingredients
from shakestir.models import Ingredient


def test_original_fixture_graph_has_resolvable_relationships_and_varied_states():
    root = DEFAULT_SEED_FILE.parent
    ingredients = {
        i["name"] for i in json.loads(DEFAULT_SEED_FILE.read_text())["ingredients"]
    }
    cocktails = {
        c["name"]: c
        for c in json.loads((root / "cocktails.json").read_text())["cocktails"]
    }
    system = json.loads((root / "recipes.json").read_text())["recipes"]
    authors = json.loads((root.parent / "demo_accounts.json").read_text())
    utensils = {
        u["name"]
        for u in json.loads((root.parent / "utensils/catalog.json").read_text())
    }
    techniques = {
        t["slug"]
        for t in json.loads((root.parent / "techniques/catalog.json").read_text())
    }
    assert len(system) > 23  # Enough public records for pagination.
    assert len({r["id"] for r in system}) == len(system)
    assert any(c["parent_cocktail"] in cocktails for c in cocktails.values())
    assert any(r["taste"] is None for r in system)
    assert any(r["taste"] and 0 in r["taste"].values() for r in system)
    all_recipes = system + authors["recipes"]
    assert any(
        r.get("visibility") == "private" and r.get("publication_state") == "draft"
        for r in all_recipes
    )
    assert any(i["optional"] for r in all_recipes for i in r["ingredients"])
    for recipe in all_recipes:
        assert recipe["cocktail"] in cocktails
        assert len(recipe["steps"]) > 1
        assert {i["name"] for i in recipe["ingredients"]} <= ingredients
        assert {u["name"] for u in recipe["utensils"]} <= utensils
        assert set(recipe["techniques"]) <= techniques
        assert all(
            float(i["quantity"]) > 0 and i["measuring_unit"]
            for i in recipe["ingredients"]
        )
    authored = {(r["user"], r["name"]) for r in authors["recipes"]}
    accounts = {a["email_address"] for a in authors["accounts"]}
    for collection in authors["collections"]:
        assert collection["user"] in accounts
        for reference in collection["recipes"]:
            assert (
                reference.get("cocktail") in cocktails
                or (reference.get("user"), reference.get("name")) in authored
            )
    for cocktail in cocktails.values():
        assert (root / "images/cocktails" / cocktail["image"]).is_file()
    assert not (root.parent / "thecocktaildb").exists()


def test_original_catalog_preserves_ice_and_non_alcoholic_identity(test_session):
    seed_ingredients(test_session)
    ice = test_session.scalars(select(Ingredient).where(Ingredient.name == "Ice")).one()
    assert ice.category == "ice"
    assert ice.alcohol_status == "non_alcoholic"
    assert ice.alcohol_by_volume == 0
