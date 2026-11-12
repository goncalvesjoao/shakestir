module Auth
  class BaseController < ApplicationController
    allow_unauthenticated_access

    before_action :prevent_session_caching

    rate_limit to: 10, within: 3.minutes, only: :create, with: -> { respond_to_rate_limit(root_path) }

    private

    def prevent_session_caching
      response.headers["Cache-Control"] = "private, no-store"
    end

    def redirect_when_authenticated
      redirect_to root_url, alert: "You are already signed in." if current_user
    end
  end
end
