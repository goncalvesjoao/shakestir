class UtensilsController < ApplicationController
  include CatalogBrowsing

  allow_unauthenticated_access only: %i[index show]

  def index
    scope = Utensil.usable.with_attached_image
    respond_to do |format|
      format.html do
        @pagination = catalog_page(scope)
        render "catalog/index", locals: { catalog_name: "utensils" }
      end
      format.json { @utensils = scope.order(Arel.sql("LOWER(name)"), :id) }
    end
  end
  def show
    @resource = Utensil.usable.with_attached_image.find(params.expect(:id))
    render "catalog/show", locals: { catalog_name: "utensils" }
  end
end
