class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private

    def current_user
      @current_user ||= User.find_by(id: payload['user_id'])
    end


    def not_authorized
      render json: { error: '認証エラーが発生しました。'}, status: :unauthorized
    end
end
