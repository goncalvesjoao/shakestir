def test_catalog_endpoints(test_app):
    schema = test_app.openapi()
    assert set(schema["paths"]) == {
        "/ingredients",
        "/ingredients/{ingredient_id}/image",
    }
    assert set(schema["paths"]["/ingredients"]) == {"get"}
    assert set(schema["paths"]["/ingredients/{ingredient_id}/image"]) == {"get"}
