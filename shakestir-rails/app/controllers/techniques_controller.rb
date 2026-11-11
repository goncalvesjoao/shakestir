class TechniquesController < ApplicationController
  include CatalogBrowsing

  allow_unauthenticated_access only: %i[index show]

  def index
    @techniques = catalog_page(Technique.all)
  end

  def show
    @technique = Technique.find_by!(slug: params[:id])
  end
end
