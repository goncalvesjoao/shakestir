class UserProfilesController < ApplicationController
  include CollectionPreviews

  before_action :prevent_user_profile_caching, only: %i[show update]

  allow_unauthenticated_access only: :show

  def show
    resume_session # Since this method does not require authentication, we resume the session if available

    @user = params[:id] == "me" ? Current.user : User.find(params[:id])

    load_content
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    attributes = params.expect(user: [ :handle, :display_name, :bio, :image, :remove_image ])
    remove_image = ActiveModel::Type::Boolean.new.cast(attributes.delete(:remove_image))

    if attributes[:image].blank?
      attributes.delete(:image)
    elsif !attributes[:image].is_a?(ActionDispatch::Http::UploadedFile)
      if request.format.json?
        return render json: { errors: { image: [ "must be an uploaded file" ] } }, status: :bad_request
      end
      raise ActionController::BadRequest, "image must be an uploaded file"
    end

    if @user.update(attributes)
      @user.image.purge_later if remove_image && !attributes.key?(:image)
      respond_to do |format|
        format.html { redirect_to my_profile_path, notice: "Profile updated.", status: :see_other }
        format.json do
          load_content
          render :show
        end
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: { errors: @user.errors.to_hash }, status: :unprocessable_content }
      end
    end
  end

  private

  def load_content
    @owned = @user == Current.user
    @collections = @user.collections.where(visibility: "public").order(created_at: :desc)
    @recipes = @user.recipes.merge(Recipe.marketplace).with_attached_image
      .includes(:recipe_steps, :techniques, :user, cocktail: { image_attachment: :blob })
      .reorder(updated_at: :desc, id: :desc)
    load_collection_previews(@collections, viewer: nil)
  end

  def prevent_user_profile_caching
    response.headers["Cache-Control"] = "private, no-store" if request.format.json?
  end
end
