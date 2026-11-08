def test_empty_catalog(test_client):
    response = test_client.get("/ingredients")
    assert response.status_code == 200
    assert response.json() == {"data": [], "metadata": {"total_count": 0}}


def test_ingredients_response_and_order(test_client, ingredient_factory):
    ingredient_factory(
        name="Vodka",
        category="spirit",
        alcohol_status="alcoholic",
        alcohol_by_volume=40,
    )
    apple_juice = ingredient_factory(name="apple juice", description="Pressed apples")
    ingredient_factory(name="Apple juice")
    response = test_client.get("/ingredients")
    assert response.status_code == 200
    body = response.json()
    assert body["metadata"] == {"total_count": 3}
    assert [row["name"] for row in body["data"]] == [
        "apple juice",
        "Apple juice",
        "Vodka",
    ]
    assert body["data"][0] == {
        "id": apple_juice.id,
        "name": "apple juice",
        "description": "Pressed apples",
        "image_url": None,
    }
    assert test_client.post("/ingredients", json={}).status_code == 405
