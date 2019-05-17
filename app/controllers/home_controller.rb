class HomeController < ApplicationController
  def index

    if Rails.env.development?
      puts "you are on development!"
    else
      puts REDIS_URL
      puts "you are on production!"
    end

    @users = User.all 
    render json: @users
  end
end
