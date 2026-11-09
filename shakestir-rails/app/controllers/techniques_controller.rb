class TechniquesController < ApplicationController
  include CatalogBrowsing

  allow_unauthenticated_access only: %i[index show]

  def index
    scope = Technique.all
    respond_to do |format|
      format.html do
        @pagination = catalog_page(scope)
        render "catalog/index", locals: { catalog_name: "techniques" }
      end
      format.json { @techniques = scope.order(Arel.sql("LOWER(name)"), :id) }
    end
  end

  def show
    @technique = Technique.find_by!(slug: params[:id])
  end
end
