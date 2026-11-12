class CollectionsController < ApplicationController
  include CollectionPreviews

  before_action :set_collection, only: %i[show edit update destroy]

  def new
    @collection = Collection.new
  end

  def show; end

  def create
    @collection = current_user.collections.new(collection_params)

    if @collection.save
      respond_to do |format|
        format.html { redirect_to @collection, notice: "Collection created." }
        format.json do
          load_collection_previews(@collection)
          render :show, status: :created, location: collection_url(@collection, format: :json)
        end
      end
    else
      render_collection_errors(:new)
    end
  end

  def edit; end

  def update
    if @collection.update(collection_params)
      respond_to do |format|
        format.html { redirect_to @collection, notice: "Collection updated.", status: :see_other }
        format.json do
          load_collection_previews(@collection)
          render :show
        end
      end
    else
      render_collection_errors(:edit)
    end
  end

  def destroy
    if @collection.destroy
      respond_to do |format|
        format.html { redirect_to collections_path, notice: "Collection deleted.", status: :see_other }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @collection, alert: "Favorites is your permanent private collection.", status: :see_other }
        format.json do
          @collection.errors.add(:base, "Favorites is your permanent private collection.") if @collection.system_key == "favorites"
          @collection.errors.add(:base, "Collection could not be deleted.") if @collection.errors.empty?
          render json: { errors: @collection.errors.to_hash }, status: :unprocessable_content
        end
      end
    end
  end

  private

  def set_collection
    @collection = current_user.collections.find(params[:id])
  end
end
