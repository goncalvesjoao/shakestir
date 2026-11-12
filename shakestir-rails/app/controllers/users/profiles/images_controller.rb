module Users
  module Profiles
    class ImagesController < BaseController
      include PhotoDelivery

      allow_unauthenticated_access only: :show

      def show
        deliver_photo(@user)
      end
    end
  end
end
