class IngredientsController < ApplicationController
  include CatalogBrowsing

  allow_unauthenticated_access only: %i[index show]

  def index
    scope = Ingredient.usable.with_attached_image
    respond_to do |format|
      format.html do
        @pagination = catalog_page(scope)
        render "catalog/index", locals: { catalog_name: "ingredients" }
      end
      format.json { @ingredients = scope.order(Arel.sql("LOWER(name)"), :id) }
    end
  end
  def show
    @resource = Ingredient.usable.with_attached_image.find(params.expect(:id))
    @recipes = Recipe.marketplace.where(id: RecipeIngredient.where(ingredient: @resource).select(:recipe_id))
      .with_attached_image.includes(:user, cocktail: { image_attachment: :blob })
      .order(published_at: :desc, id: :desc)
    render "catalog/show", locals: { catalog_name: "ingredients" }
  end
end
