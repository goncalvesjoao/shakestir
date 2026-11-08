from pydantic import BaseModel


class IngredientPublic(BaseModel):
    id: int
    name: str
    description: str | None
    image_url: str | None = None


class IngredientMetadata(BaseModel):
    total_count: int


class IngredientList(BaseModel):
    data: list[IngredientPublic]
    metadata: IngredientMetadata
