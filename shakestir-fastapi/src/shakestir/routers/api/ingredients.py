from fastapi import APIRouter, HTTPException, Request
from fastapi.responses import FileResponse

from shakestir.dependencies import GetSession
from shakestir.models import Ingredient
from shakestir.repositories.ingredients import find_all
from shakestir.schemas.ingredient import (
    IngredientList,
    IngredientMetadata,
    IngredientPublic,
)
from shakestir.storage import image_path

router = APIRouter(tags=["ingredients"])


@router.get("/ingredients", response_model=IngredientList)
def get_ingredients(session: GetSession, request: Request) -> IngredientList:
    records = find_all(session)
    return IngredientList(
        data=[
            IngredientPublic(
                id=record.id,
                name=record.name,
                description=record.description,
                image_url=str(
                    request.url_for("get_ingredient_image", ingredient_id=record.id)
                )
                if record.image_key and image_path(record.image_key).is_file()
                else None,
            )
            for record in records
        ],
        metadata=IngredientMetadata(total_count=len(records)),
    )


@router.get(
    "/ingredients/{ingredient_id}/image",
    response_class=FileResponse,
    responses={404: {"description": "Image not found"}},
)
def get_ingredient_image(ingredient_id: int, session: GetSession) -> FileResponse:
    ingredient = session.get(Ingredient, ingredient_id)
    if ingredient is None or not ingredient.image_key:
        raise HTTPException(status_code=404, detail="Image not found")
    path = image_path(ingredient.image_key)
    if not path.is_file():
        raise HTTPException(status_code=404, detail="Image not found")
    return FileResponse(path)
