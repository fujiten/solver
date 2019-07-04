module Api 
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show]
      before_action :authorize_access_request!, only: [:update, :show_mypage]

      def show
        render json: @user
      end

      def update
        @user = current_user
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def show_mypage

        # draftedとpublishedをそれぞれグループ化してクライアントに返す。
        @my_quizzes = current_user.my_quizzes.group_by{ |quiz| quiz.published }

        @grouped_my_quiz_statuses = QuizStatus.where(user_id: current_user.id).includes(:quiz)
        @trying_quizzes = @grouped_my_quiz_statuses.where(be_solved: false).map{ |status| status.quiz }
        @solved_quizzes = @grouped_my_quiz_statuses.where(be_solved: true).map{ |status| status.quiz }

        @combination = { my_quizzes: @my_quizzes,
                         trying_quizzes: @trying_quizzes,
                         solved_quizzes: @solved_quizzes,
                         current_user: current_user }
        render json: @combination 
      end

      private

        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(:name, :description)
        end
      
    end
  end
end
