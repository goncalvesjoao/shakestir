module Recipes
  class StarsController < BaseController
    before_action :authorize_user

    def create
      current_user.favorites_collection.collection_recipes.find_or_create_by!(recipe: @recipe)

      respond_with_star(@recipe, "Recipe starred in your private Favorites.")
    end

    def destroy
      current_user.favorites_collection.collection_recipes.find_by(recipe: @recipe)&.destroy!

      respond_with_star(@recipe, "Recipe unstarred.")
    end

    private

    def authorize_user
      authorize @recipe
    end

    def respond_with_star(recipe, message)
      respond_to do |format|
        format.html do
          redirect_back_or_to recipe, allow_other_host: false, notice: message, status: :see_other
        end

        format.json do
          favorites = current_user.favorites_collection

          render json: {
            recipe_id: recipe.id,
            starred: favorites.collection_recipes.exists?(recipe: recipe),
            star_count: recipe.reload.stars_count,
            favorites_collection_id: favorites.id
          }
        end
      end
    end
    end
  end
end
