module Users
  class AccountsController < BaseController
    def show; end

    def destroy
      unless current_user.authenticate(params[:password].to_s)
        current_user.errors.add(:password, "is incorrect")
        return render_deletion_errors
      end

      current_user.destroy!
      cookies.delete(:session_id)
      Current.reset
      reset_session
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Your account and its content have been deleted.", status: :see_other }
        format.json { head :no_content }
      end
    rescue ActiveRecord::RecordNotDestroyed
      current_user.errors.add(:base, "Your account could not be deleted. Please try again.")
      render_deletion_errors
    end

    private

    def render_deletion_errors
      respond_to do |format|
        format.html { render :show, status: :unprocessable_content }
        format.json { render json: { errors: current_user.errors.to_hash }, status: :unprocessable_content }
      end
    end
  end
end
