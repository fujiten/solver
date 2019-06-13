module Api 
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show]
      before_action :authorize_access_request!, only: [:show_mypage]

      def show
        render json: @user
      end

      def show_mypage
        render json: current_user
      end

      private

        def set_user
          @user = User.find(params[:id])
        end
      
    end
  end
end
