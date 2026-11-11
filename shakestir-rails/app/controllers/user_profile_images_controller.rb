class UserProfileImagesController < ApplicationController
  include PhotoDelivery
  allow_unauthenticated_access only: :show

  def show
    @user = User.find(params[:user_profile_id])

    deliver_photo(@user)
  end
end
