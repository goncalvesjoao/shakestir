import json

from sqlalchemy import select

from scripts.db.seed.ingredients import DEFAULT_SEED_FILE, seed_ingredients
from shakestir.models import Ingredient
from shakestir.storage import image_path, store_image


def test_seed_images_are_copied_and_served(test_session, test_client):
    seed_ingredients(test_session)
    test_session.commit()
    records = test_session.scalars(select(Ingredient)).all()
    assert records
    for record in records:
        slug = record.name.lower().replace(" ", "-")
        cached = DEFAULT_SEED_FILE.parent / f"images/ingredients/{slug}.png"
        assert bool(record.image_key) == cached.is_file()
    gin = next(record for record in records if record.name == "Gin")
    source = DEFAULT_SEED_FILE.parent / "images/ingredients/gin.png"
    assert image_path(gin.image_key).read_bytes() == source.read_bytes()
    data = test_client.get("/ingredients").json()["data"]
    url = next(row["image_url"] for row in data if row["id"] == gin.id)
    response = test_client.get(url)
    assert response.status_code == 200
    assert response.headers["content-type"] == "image/png"
    assert response.content == source.read_bytes()
    assert test_client.get(url, headers={"Range": "bytes=0-7"}).status_code == 206


def test_rerun_preserves_images_and_restores_matching_missing_files(test_session):
    seed_ingredients(test_session)
    test_session.commit()
    gin = test_session.scalars(select(Ingredient).where(Ingredient.name == "Gin")).one()
    key, updated_at = gin.image_key, gin.updated_at
    path = image_path(key)
    modified_at = path.stat().st_mtime_ns
    seed_ingredients(test_session)
    test_session.commit()
    assert path.stat().st_mtime_ns == modified_at
    path.unlink()
    seed_ingredients(test_session)
    test_session.commit()
    assert path.is_file()
    assert gin.image_key == key
    assert gin.updated_at == updated_at


def test_existing_custom_image_is_preserved_even_when_missing(test_session, tmp_path):
    seed_ingredients(test_session)
    test_session.commit()
    gin = test_session.scalars(select(Ingredient).where(Ingredient.name == "Gin")).one()
    custom = tmp_path / "custom.png"
    custom.write_bytes(b"curated image")
    gin.image_key = store_image(custom)
    test_session.commit()
    key = gin.image_key
    seed_ingredients(test_session)
    test_session.commit()
    assert gin.image_key == key
    assert image_path(key).read_bytes() == b"curated image"
    image_path(key).unlink()
    seed_ingredients(test_session)
    test_session.commit()
    assert gin.image_key == key
    assert not image_path(key).exists()


def test_missing_seed_image_does_not_prevent_import(
    test_session, test_client, tmp_path
):
    seed = tmp_path / "ingredients.json"
    seed.write_text(json.dumps({"ingredients": [{"strIngredient": "Missing picture"}]}))
    seed_ingredients(test_session, seed)
    test_session.commit()
    record = test_session.scalars(select(Ingredient)).one()
    assert record.image_key is None
    assert test_client.get("/ingredients").json()["data"][0]["image_url"] is None
    assert test_client.get(f"/ingredients/{record.id}/image").status_code == 404
    assert test_client.get("/ingredients/999999/image").status_code == 404


def test_missing_stored_file_returns_404(test_session, test_client):
    seed_ingredients(test_session)
    test_session.commit()
    gin = test_session.scalars(select(Ingredient).where(Ingredient.name == "Gin")).one()
    image_path(gin.image_key).unlink()
    assert test_client.get(f"/ingredients/{gin.id}/image").status_code == 404
    assert (
        next(
            row
            for row in test_client.get("/ingredients").json()["data"]
            if row["id"] == gin.id
        )["image_url"]
        is None
    )


def test_pineapple_juice_has_a_cached_image_and_backfills_existing_records(
    test_session, test_client
):
    ingredient = Ingredient(name="Pineapple Juice")
    test_session.add(ingredient)
    test_session.commit()
    seed_ingredients(test_session)
    test_session.commit()
    test_session.refresh(ingredient)
    assert ingredient.image_key is not None
    source = DEFAULT_SEED_FILE.parent / "images/ingredients/pineapple-juice.png"
    response = test_client.get(f"/ingredients/{ingredient.id}/image")
    assert response.status_code == 200
    assert response.content == source.read_bytes()
