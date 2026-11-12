module Users
  class CollectionsController < BaseController
    include CollectionPreviews

    def index
      @collections = @user.collections.includes(:user).order(:created_at)

      load_collection_previews(@collections, viewer: @user)
    end
  end
end
