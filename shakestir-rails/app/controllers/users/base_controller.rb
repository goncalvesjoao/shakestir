module Users
  class BaseController < ApplicationController
    before_action :set_user
    before_action :authorize_user

    private

    def set_user
      resume_session # Since some actions may not require authentication, we need to resume in case they don't.

      @user = params[:user_handle] == "my" ? Current.user : User.find_by!(handle: params[:user_handle])
    end

    def authorize_user
      authorize @user || User
    end
  end
end
