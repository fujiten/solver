# frozen_string_literal: true

class AuthenticationController < ApplicationController

  def twitter

    twitter_login = Authentication::TwitterLogin.new

    request_token = twitter_login.fetch_request_token_after_callback(request)
    access_token= twitter_login.get_access_token_from(request_token, params)
    twitter_response = twitter_login.get_account_info(access_token)

    case twitter_response
    when Net::HTTPSuccess
      user_info = JSON.parse(twitter_response.body)

      if user_info["screen_name"]

        user = User.find_or_create(user_info, "twitter")

        if user.persisted?

          payload = { user_id: user.id }
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
          tokens = session.login
          cookie_key_value_pairs = {
            "oauth_token2" => access_token.params["oauth_token"],
            "oauth_token_secret" => access_token.params["oauth_token_secret"],
            "csrf" => tokens[:csrf],
            "ac_token" => tokens[:access]
          }

          set_cookies_at_once(response, cookie_key_value_pairs)

          response.set_cookie("signedIn",
            value: true,
            domain: ENV["BASE_DOMAIN"],
            path: "/",
            secure: Rails.env.production?)

          set_cookie_at_token_validness(true)

          redirect_to ENV["CLIANT_SIDE_TOP_PAGE"]

        else

          redirect_to ENV["CLIANT_SIDE_TOP_PAGE"]

        end

      else
        set_cookie_at_token_validness(false)
        render json: { status: "authentication_failed" }
      end

    else
      set_cookie_at_token_validness(false)
      render json: { status: "authentication_failed" }
    end

  end

  def authenticate

    # クッキー内にアクセストークン発行のためのトークンがあれば、それを利用して認可をスキップ
    if true?(request.cookies["token_validness"]) && request.cookies["oauth_token2"] && request.cookies["oauth_token_secret"]

      twitter_login = Authentication::TwitterLogin.new

      access_token = twitter_login.get_access_token(request.cookies["oauth_token2"], request.cookies["oauth_token_secret"])
      twitter_response = twitter_login.get_account_info(access_token)

      case twitter_response
      when Net::HTTPSuccess

        user_info = JSON.parse(twitter_response.body)

        if user_info["screen_name"]

          user = User.find_by(uid: user_info["id"], provider: "twitter")

          payload = { user_id: user.id }
          session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
          tokens = session.login

          response.set_cookie(JWTSessions.access_cookie,
                            value: tokens[:access],
                            httponly: true,
                            secure: Rails.env.production?)

          response.set_cookie("signedIn",
                            value: true,
                            domain: ENV["BASE_DOMAIN"],
                            httponly: true,
                            path: "/",
                            secure: Rails.env.production?)

          render json: { status: "authentication_success", csrf: tokens[:csrf], my_avatar: user.avatar.encode(:icon), uid: user.id }

        else
          set_cookie_at_token_validness(false)
          render json: { status: "authentication_failed" }
        end

      when  Net::HTTPUnauthorized
        set_cookie_at_token_validness(false)
        render json: { status: "authentication_failed" }
      end

    # クッキーに認可のためのトークンがない場合は、認可のためのコールバックURLを返答する
    else
      twitter_login = Authentication::TwitterLogin.new
      request_token = twitter_login.get_request_token
      twitter_login.set_request_tokens_in_cookie(response, request_token)

      rtn = {}
      rtn["status"] = "return_callback_url"
      rtn["oauth_url"] = request_token.authorize_url

      render json: rtn
    end
  end

  private

    def set_cookies_at_once(response, key_value = {})
      key_value.each do |key, value|
        response.set_cookie(key,
          value: value,
          httponly: true,
          domain: ENV["BASE_DOMAIN"],
          path: "/",
          secure: Rails.env.production?)
      end
    end

    def true?(value)
      value.to_s == "true"
    end

    def set_cookie_at_token_validness(boolian)
      response.set_cookie("token_validness",
        value: boolian,
        httponly: true,
        domain: ENV["BASE_DOMAIN"],
        path: "/",
        secure: Rails.env.production?)
    end

end
