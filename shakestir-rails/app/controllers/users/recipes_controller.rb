module Users
  class RecipesController < BaseController
    def index
      @publication_state = params[:state].presence_in(%w[draft published])

      @recipe_counts = @user.recipes.group(:publication_state).count
      @recipes = @user.recipes.search(params[:q])

      @recipes = @recipes.where(publication_state: @publication_state) if @publication_state

      @recipes = @recipes.with_attached_image.includes(:recipe_steps, :techniques, :user, cocktail: { image_attachment: :blob })
        .order(updated_at: :desc, id: :desc)

      @recipes = @recipes.page(params[:page]).per(24)
    end
  end
end
