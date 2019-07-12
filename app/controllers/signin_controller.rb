class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      JWTSessions.access_exp_time = 10
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      p JWTSessions.access_cookie

      response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: true)
                        # , my_avatar: user.avatar.encode
      render json: { csrf: tokens[:csrf], access: tokens[:access], response: response.headers }
    else
      # this method is inherited from ApplicationController
      not_authorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: :ok
  end

  private

    def not_found
      render json: { error: "メールアドレスとパスワードの組み合わせが見つかりません"}, status: :not_found
    end
    
end
