class HomeController < ApplicationController
  def index
    puts REDIS_URL
    @users = User.all 
    render json: @users
  end
end
