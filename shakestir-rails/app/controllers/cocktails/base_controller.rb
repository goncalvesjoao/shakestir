module Cocktails
  class BaseController < ApplicationController
    before_action :set_cocktail

    private

    def set_cocktail
      @cocktail = Cocktail.find(params[:cocktail_id])
    end
  end
end
