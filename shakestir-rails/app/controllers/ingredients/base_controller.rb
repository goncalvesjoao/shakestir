module Ingredients
  class BaseController < ApplicationController
    before_action :set_ingredient

    private

    def set_ingredient
      @ingredient = Ingredient.find(params[:ingredient_id])
    end
  end
end
