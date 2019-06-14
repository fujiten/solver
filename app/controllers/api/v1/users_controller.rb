module Api 
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show]
      before_action :authorize_access_request!, only: [:show_mypage]

      def show
        render json: @user
      end

      def show_mypage
        # draftedとpublishedをそれぞれグループ化してクライアントに返す。
        @my_quizzes = current_user.my_quizzes.to_a.group_by{ |quiz| quiz.published }
        @combination = {my_quizzes: @my_quizzes, current_user: current_user }
        render json: @combination
      end

      private

        def set_user
          @user = User.find(params[:id])
        end
      
    end
  end
end
