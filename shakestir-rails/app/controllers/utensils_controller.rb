class UtensilsController < ApplicationController
  include CatalogBrowsing

  allow_unauthenticated_access only: %i[index show]

  def index
    @utensils = catalog_page(Utensil.usable.with_attached_image)
  end

  def show
    @utensil = Utensil.usable.with_attached_image.find(params.expect(:id))
  end
end
