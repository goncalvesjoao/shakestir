module Utensils
  class ImagesController < BaseController
    include PhotoDelivery

    allow_unauthenticated_access only: :show

    def show
      deliver_photo(@utensil)
    end
  end
end
