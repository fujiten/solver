class Authentication::TwitterLogin

  def initialize
    @consumer ||= consumer
  end

  def get_request_token
    consumer.get_request_token(oauth_callback: ENV['TWITTER_CALLBACK_URL'])
  end

  def get_access_token(oauth_token, oauth_token_secret)
    OAuth::AccessToken.new(
      consumer,
      oauth_token,
      oauth_token_secret
    )
  end

  def get_access_token_from(request_token, params)
    request_token.get_access_token(
      {},
      :oauth_token => params[:oauth_token],
      :oauth_verifier => params[:oauth_verifier]
    )
  end

  def fetch_request_token_after_callback(request)
    OAuth::RequestToken.new(
      consumer,
      request.cookies['request_token'],
      request.cookies['request_token_secret']
    )
  end

  def get_account_info(access_token)
    consumer.request(
      :get,
      '/1.1/account/verify_credentials.json',
      access_token, { :scheme => :query_string }
    )
  end

  def set_request_tokens_in_cookie(response, request_token)
    response.set_cookie("request_token",
      value: request_token.token,
      httponly: true,
      secure: Rails.env.production?)

    response.set_cookie("request_token_secret",
      value: request_token.secret,
      httponly: true,
      secure: Rails.env.production?)
  end

  private

    def consumer
      @consumer ||= OAuth::Consumer.new(
        ENV['TWITTER_CONSUMER_KEY'],
        ENV['TWITTER_CONSUMER_KEY_SECRET'],
        { :site => "https://api.twitter.com" }
      )
    end

end
