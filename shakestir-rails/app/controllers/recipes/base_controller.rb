module Recipes
  class BaseController < ApplicationController
    before_action :set_recipe

    private

    def set_recipe
      @recipe = Recipe.find(params[:recipe_id])
    end
  end
end
