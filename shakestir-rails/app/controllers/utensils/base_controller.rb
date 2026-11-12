module Utensils
  class BaseController < ApplicationController
    before_action :set_utensil

    private

    def set_utensil
      @utensil = Utensil.find(params[:utensil_id])
    end
  end
end
