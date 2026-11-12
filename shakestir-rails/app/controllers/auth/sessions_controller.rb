module Auth
  class SessionsController < BaseController
    before_action :require_authentication, only: %i[ destroy ]    

    def new; end

    def show
      @user = current_user
    end

    def create
      if user = User.authenticate_by(params.permit(:email_address, :password))
        start_new_session_for user
        respond_to do |format|
          format.html { redirect_to after_authentication_url }
          format.json do
            @user = user
            render :show
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to new_session_path, alert: "Try another email address or password." }
          format.json { render json: { errors: { base: [ "Try another email address or password." ] } }, status: :unauthorized }
        end
      end
    end

    def destroy
      terminate_session

      respond_to do |format|
        format.html { redirect_to new_session_path, status: :see_other }
        format.json do
          @user = nil
          render :show
        end
      end
    end
  end
end
