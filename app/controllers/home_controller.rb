# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end
end
