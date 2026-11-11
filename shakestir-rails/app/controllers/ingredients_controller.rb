class IngredientsController < ApplicationController
  include CatalogBrowsing

  allow_unauthenticated_access only: %i[index show]

  def index
    @ingredients = catalog_page(Ingredient.usable.with_attached_image)
  end

  def show
    @ingredient = Ingredient.usable.with_attached_image.find(params.expect(:id))

    @recipes = Recipe.marketplace.where(id: RecipeIngredient.where(ingredient: @ingredient).select(:recipe_id))
      .with_attached_image.includes(:user, cocktail: { image_attachment: :blob })
      .order(published_at: :desc, id: :desc)
  end
end
