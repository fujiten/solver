class AuthenticationController < ApplicationController

  def twitter

    request_token = OAuth::RequestToken.new(
      consumer,
      request.cookies['request_token'],
      request.cookies['request_token_secret']
    )

    access_token = request_token.get_access_token(
      {},
      :oauth_token => params[:oauth_token],
      :oauth_verifier => params[:oauth_verifier]
    )

    twitter_response = consumer.request(
      :get,
      '/1.1/account/verify_credentials.json',
      access_token, { :scheme => :query_string }
    )

    case twitter_response
    when Net::HTTPSuccess
      user_info = JSON.parse(twitter_response.body)

      if user_info["screen_name"]

        user = User.find_or_create(user_info, 'twitter')
        p user

        if user.persisted?

          payload = { user_id: user.id }
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
          tokens = session.login
          cookie_key_value_pairs = {

            'oauth_token2' => access_token.params["oauth_token"],
            'oauth_token_secret' => access_token.params["oauth_token_secret"],
            'csrf' => tokens[:csrf]
          }

          set_cookies_at_once(response, cookie_key_value_pairs)

          response.set_cookie('ac_token',
          value: tokens[:access],
          domain: ".seasolver.club",
          path: "/",
          secure: Rails.env.production?)

          response.set_cookie('signedIn',
          value: true,
          domain: ".seasolver.club",
          path: "/",
          secure: Rails.env.production?)

          response.set_cookie('token_validness',
          value: true,
          domain: ".seasolver.club",
          path: "/",
          secure: Rails.env.production?)

          redirect_to 'https://www.seasolver.club/'

        else

          redirect_to 'https://www.seasolver.club/'

        end

      else
        #"Authentication failed"
      end

    else
      #"Failed to get user info via OAuth"
    end

  end

  def authenticate

    # クッキー内にアクセストークン発行のためのトークンがあれば、それを利用して認可をスキップ
    if true?(request.cookies["token_validness"]) && request.cookies["oauth_token2"] && request.cookies['oauth_token_secret']

      access_token = OAuth::AccessToken.new(
        consumer,
        request.cookies['oauth_token2'],
        request.cookies['oauth_token_secret']
      )
      

      twitter_response = consumer.request(
        :get,
        '/1.1/account/verify_credentials.json',
        access_token, { :scheme => :query_string }
      )

      case twitter_response
      when Net::HTTPSuccess

        user_info = JSON.parse(twitter_response.body)

        if user_info["screen_name"]

          user = User.find_by(uid: user_info['id'], provider: 'twitter')

          payload = { user_id: user.id }
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
          tokens = session.login
    
          response.set_cookie(JWTSessions.access_cookie,
                            value: tokens[:access],
                            httponly: true,
                            secure: Rails.env.production?)
          render json: { status: "authentication_success", csrf: tokens[:csrf], my_avatar: user.avatar.encode(:icon), uid: user.id }

        else
          render json: { status: "authentication_failed" }
        end

      when  Net::HTTPUnauthorized
        render json: { status: "authentication_failed" }
      end

    # クッキーに認可のためのトークンがない場合は、認可のためのコールバックURLを返答する
    else
  
      request_token = consumer.get_request_token(
        :oauth_callback => "https://api.seasolver.club/auth/twitter/callback"
      )

      response.set_cookie("request_token",
        value: request_token.token,
        httponly: true,
        secure: Rails.env.production?)

      response.set_cookie("request_token_secret",
        value: request_token.secret,
        httponly: true,
        secure: Rails.env.production?)
  
      rtn = {}
      rtn["status"] = 'return_callback_url'
      rtn["oauth_url"] = request_token.authorize_url
  
      render json: rtn
    end
  end

  private

    def consumer
      @consumer ||= OAuth::Consumer.new(
        ENV['TWITTER_CONSUMER_KEY'],
        ENV['TWITTER_CONSUMER_KEY_SECRET'],
        { :site => "https://api.twitter.com" }
      )
    end

    def set_cookies_at_once(response, key_value = {})
      key_value.each do |key, value|
        response.set_cookie(key,
          value: value,
          httponly: true,
          domain: ".seasolver.club",
          path: "/",
          secure: Rails.env.production?)
      end
    end

    def true?(value)
      value.to_s == "true"
    end

end
