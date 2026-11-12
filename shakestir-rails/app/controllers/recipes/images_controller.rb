module Recipes
  class ImagesController < BaseController
    include PhotoDelivery

    allow_unauthenticated_access only: :show

    def show
      deliver_photo(@recipe)
    end
  end
end
