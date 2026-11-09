module CatalogBrowsing
  extend ActiveSupport::Concern

  private
    def catalog_page(scope)
      scope.search(params[:q]).order(Arel.sql("LOWER(name)"), :id).page(params[:page]).per(24)
    end
end
