module Ingredients
  class ImagesController < BaseController
    include PhotoDelivery

    allow_unauthenticated_access only: :show

    def show
      deliver_photo(@ingredient)
    end
  end
end
