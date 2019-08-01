class SignupController < ApplicationController

  def create
    User.new(user_params).create_user_and_avatar
    if user.persisted?
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      
      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
      render json: { csrf: tokens[:csrf], my_avatar: user.avatar.encode(:icon), uid: user.id }
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:email, :name, :password, :password_confirmation)
  end
  
end
