"""Rebuild original, deterministic demo JSON. Does not download or generate images."""

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SEEDS = ROOT / "db/seeds"
DEMO = SEEDS / "demo"


def write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")


def slug(name):
    return name.lower().replace(" ", "-")


def line(name, quantity, unit="ml", optional=False, role="mixing"):
    return {
        "name": name,
        "submitted_text": f"{quantity} {unit} {name}",
        "quantity": str(quantity),
        "measuring_unit": unit,
        "optional": optional,
        "role": role,
        "preparation_note": None,
    }


def fingerprint(recipe):
    lines = [
        [
            i["name"].lower(),
            i["submitted_text"],
            f"{float(i['quantity']):.1f}",
            i["measuring_unit"],
            i["optional"],
            i["role"],
            i["preparation_note"],
        ]
        for i in recipe["ingredients"]
    ]
    return hashlib.sha256(
        json.dumps(
            [lines, recipe["steps"]], ensure_ascii=False, separators=(",", ":")
        ).encode()
    ).hexdigest()


def main():
    ingredients = [
        (
            "Gin",
            "spirit",
            "Yes",
            "40",
            "Clear botanical spirit used as the base of the Garden Spark demo.",
        ),
        (
            "Vodka",
            "spirit",
            "Yes",
            "40",
            "Neutral clear spirit for the Midnight Cloud demo recipes.",
        ),
        (
            "Rum",
            "spirit",
            "Yes",
            "40",
            "Golden cane spirit giving the Island Drift demo a warm base.",
        ),
        (
            "Tequila",
            "spirit",
            "Yes",
            "40",
            "Pale agave spirit used in the two Lantern cocktail families.",
        ),
        (
            "Bourbon",
            "spirit",
            "Yes",
            "40",
            "Amber grain spirit for the stirred Amber Evening demo.",
        ),
        (
            "Lime Juice",
            "juice",
            "No",
            "0",
            "Cloudy pale-green juice that supplies acidity to these sample recipes.",
        ),
        (
            "Triple Sec",
            "liqueur",
            "Yes",
            "30",
            "Clear orange liqueur adding citrus sweetness to the Lantern demos.",
        ),
        (
            "Bitters",
            "spice",
            "Yes",
            "40",
            "Concentrated aromatic seasoning, measured by dashes in the amber demos.",
        ),
        (
            "Mint",
            "mint",
            "No",
            "0",
            "Fresh green leaves used for gentle muddling and optional garnishes.",
        ),
        (
            "Pineapple Juice",
            "juice",
            "No",
            "0",
            "Opaque yellow fruit juice giving Island Drift its color and body.",
        ),
        (
            "Sugar Syrup",
            "syrup",
            "No",
            "0",
            "A simple sugar-and-water sweetener for the original demo formulations.",
        ),
        (
            "Coffee Liqueur",
            "liqueur",
            "Yes",
            "20",
            "Dark coffee-flavored liqueur providing the Midnight Cloud color.",
        ),
        (
            "Soda Water",
            "mixer",
            "No",
            "0",
            "Plain sparkling water added after mixing to retain its bubbles.",
        ),
        (
            "Espresso",
            "mixer",
            "No",
            "0",
            "Freshly brewed concentrated coffee providing the Midnight Cloud foam and aroma.",
        ),
        (
            "Ice",
            "ice",
            "No",
            "0",
            "Frozen water counted as an ingredient for chilling, dilution and frozen texture.",
        ),
    ]
    write(
        DEMO / "ingredients.json",
        {
            "provenance": "Original ShakeStir fictional UI fixtures; illustrative ABV values, not product specifications.",
            "ingredients": [
                {"name": n, "type": t, "alcohol": a, "abv": b, "description": d}
                for n, t, a, b, d in ingredients
            ],
        },
    )
    families = [
        (
            "Citrus Lantern",
            "Coupe glass",
            ["Jigger", "Boston shaker", "Hawthorne strainer", "Coupe glass"],
            ["shake", "strain"],
            [
                ("Tequila", 45),
                ("Triple Sec", 20),
                ("Lime Juice", 25),
                ("Sugar Syrup", 5),
            ],
            [
                "Measure the liquids with a Jigger into a Boston shaker.",
                "Add Ice and shake until the tins feel cold.",
                "Strain into a chilled Coupe glass without serving ice. An optional lime wheel and partial salt rim are styling suggestions.",
            ],
            [2, 4, 0],
        ),
        (
            "Garden Spark",
            "Highball glass",
            ["Jigger", "Muddler", "Bar spoon", "Highball glass"],
            ["muddle", "build"],
            [("Gin", 40), ("Lime Juice", 20), ("Sugar Syrup", 15), ("Soda Water", 100)],
            [
                "Gently press Mint with the syrup in a Highball glass using a Muddler.",
                "Add the base spirit, lime juice and Ice; lift once with a Bar spoon.",
                "Add Soda Water gently and finish with a small optional Mint sprig.",
            ],
            [2, 3, 0],
        ),
        (
            "Island Drift",
            "Hurricane glass",
            ["Jigger", "Boston shaker", "Hawthorne strainer", "Hurricane glass"],
            ["shake", "strain"],
            [
                ("Rum", 40),
                ("Pineapple Juice", 90),
                ("Lime Juice", 15),
                ("Sugar Syrup", 10),
            ],
            [
                "Measure Rum, Pineapple Juice, Lime Juice and syrup into a Boston shaker.",
                "Shake with Ice until chilled.",
                "Strain over crushed Ice in a Hurricane glass. An optional pineapple wedge matches the serving illustration.",
            ],
            [3, 3, 0],
        ),
        (
            "Amber Evening",
            "Rocks glass",
            [
                "Jigger",
                "Mixing glass",
                "Bar spoon",
                "Hawthorne strainer",
                "Rocks glass",
            ],
            ["stir", "strain"],
            [("Bourbon", 50), ("Sugar Syrup", 5), ("Bitters", 2, "dash")],
            [
                "Measure Bourbon, syrup and Bitters into a Mixing glass.",
                "Add Ice and stir gently with a Bar spoon until cold.",
                "Strain into a Rocks glass over one large clear ice cube.",
            ],
            [1, 0, 3],
        ),
        (
            "Midnight Cloud",
            "Coupe glass",
            ["Jigger", "Boston shaker", "Hawthorne strainer", "Coupe glass"],
            ["shake", "strain"],
            [
                ("Vodka", 35),
                ("Coffee Liqueur", 25),
                ("Espresso", 25),
                ("Sugar Syrup", 5),
            ],
            [
                "Measure Vodka, Coffee Liqueur, cooled Espresso and syrup into a Boston shaker.",
                "Add Ice and shake firmly to aerate the surface.",
                "Strain into a chilled Coupe glass without ice. The illustration uses a few optional coffee beans on the light foam.",
            ],
            [3, 0, 2],
        ),
        (
            "Frozen Lantern",
            "Margarita glass",
            ["Jigger", "Blender", "Margarita glass"],
            ["blend"],
            [
                ("Tequila", 40),
                ("Triple Sec", 20),
                ("Lime Juice", 25),
                ("Sugar Syrup", 10),
            ],
            [
                "Measure the liquids into an ice-capable Blender.",
                "Add the measured Ice, close the lid and blend to a smooth fine slush.",
                "Pour into a Margarita glass. An optional lime wheel and partial salt rim match the illustration.",
            ],
            [3, 4, 0],
        ),
    ]
    cocktails, recipes = [], []
    for name, glass, tools, techniques, spec, steps, taste in families:
        key = slug(name)
        cocktails.append(
            {
                "name": name,
                "description": f"A fictional {name.lower()} prepared for ShakeStir interface testing and served in a {glass.lower()}.",
                "history": "Created as an original ShakeStir demo family. The four example preparations explore sweetness and serving choices; this is not a historical cocktail account.",
                "source_reference": "ShakeStir original demo",
                "source_url": f"https://shakestir.example/cocktails/{key}",
                "source_date_note": "Fictional test content; no historical publication date.",
                "glassware": glass,
                "image": f"{key}.png",
                "parent_cocktail": "Citrus Lantern"
                if name == "Frozen Lantern"
                else None,
            }
        )
        for index, label in enumerate(["", "Soft", "Dry", "Notebook"]):
            lines = [line(*item) for item in spec]
            for item in lines:
                if item["name"] == "Sugar Syrup" and index in (1, 2):
                    item["quantity"] = str(
                        float(item["quantity"]) + (5 if index == 1 else -3)
                    )
                    item["submitted_text"] = f"{item['quantity']} ml Sugar Syrup"
            if name == "Garden Spark":
                lines += [
                    line("Mint", 6, "leaf"),
                    line("Mint", 1, "sprig", True, "garnish"),
                ]
                if index == 3:
                    lines = [i for i in lines if i["name"] != "Gin"]
            lines.append(line("Ice", 150 if name == "Frozen Lantern" else 100, "g"))
            own_steps = steps.copy()
            if name == "Garden Spark" and index == 3:
                own_steps[1] = (
                    "Add Lime Juice and Ice without any spirit; lift once with a Bar spoon."
                )
            recipe = {
                "id": f"{key}-{index + 1:02}",
                "name": name if not label else f"{label} {name}",
                "cocktail": name,
                "ingredients": lines,
                "utensils": [
                    {
                        "name": t,
                        "submitted_text": t,
                        "role": "serving" if t == glass else "preparation",
                    }
                    for t in tools
                ],
                "steps": own_steps,
                "techniques": techniques,
                "taste": None
                if index == 3
                else dict(
                    zip(
                        ["sweetness", "sourness", "bitterness"],
                        [
                            min(
                                5,
                                taste[0]
                                + (1 if index == 1 else -1 if index == 2 else 0),
                            ),
                            *taste[1:],
                        ],
                    )
                ),
            }
            recipe["spec_fingerprint"] = fingerprint(recipe)
            recipes.append(recipe)
    write(DEMO / "cocktails.json", {"cocktails": cocktails})
    write(DEMO / "recipes.json", {"recipes": recipes})
    existing = json.loads((SEEDS / "demo_accounts.json").read_text())
    choices = [
        ("Midnight Velvet", "Midnight Cloud", 0),
        ("Garden Notebook", "Garden Spark", 0),
        ("Snowfall Lantern", "Citrus Lantern", 1),
        ("My Weekend Lantern", "Citrus Lantern", 0),
        ("After Dinner Experiment", "Midnight Cloud", 1),
    ]
    authored = []
    for (name, family, variation), old in zip(choices, existing["recipes"]):
        base = next(
            r
            for r in recipes
            if r["cocktail"] == family and r["id"].endswith(f"{variation + 1:02}")
        )
        authored.append(
            {
                **base,
                "id": name.lower().replace(" ", "-"),
                "name": name,
                "user": old["user"],
                "visibility": old["visibility"],
                "publication_state": old["publication_state"],
            }
        )
    replacements = {
        "Ruby Masquerade": "Garden Notebook",
        "Snowfall Sidecar": "Snowfall Lantern",
        "My Weekend Margarita": "My Weekend Lantern",
        "Negroni": "Amber Evening",
        "Old Fashioned": "Amber Evening",
        "Mojito": "Garden Spark",
        "Daiquiri": "Island Drift",
        "Manhattan": "Amber Evening",
        "Gimlet": "Citrus Lantern",
    }
    for collection in existing["collections"]:
        for ref in collection["recipes"]:
            for field in ("name", "cocktail"):
                if field in ref:
                    ref[field] = replacements.get(ref[field], ref[field])
    existing["recipes"] = authored
    write(SEEDS / "demo_accounts.json", existing)
    # Original utensil illustrations are retained; add a serving vessel for Island Drift.
    utensils = json.loads((SEEDS / "utensils/catalog.json").read_text())
    if not any(t["name"] == "Hurricane glass" for t in utensils):
        utensils.append(
            {
                "slug": "hurricane-glass",
                "name": "Hurricane glass",
                "category": "glassware",
                "description": "A curved, footed serving glass for long fruit drinks and crushed ice.",
                "image_subject": "empty clear hurricane cocktail glass with short stem and round foot",
            }
        )
    write(SEEDS / "utensils/catalog.json", utensils)
    print(
        f"Wrote {len(ingredients)} ingredients, {len(cocktails)} cocktails, {len(recipes)} system recipes and {len(authored)} author recipes."
    )


if __name__ == "__main__":
    main()
