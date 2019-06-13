module Api 
  module V1
    class QuizzesController < ApplicationController
      # before_action :set_quiz, only: [:show] 
      before_action :authorize_access_request!, only: [:create, :solve, :show_my_quizzes]
      
      def index
        @quizzes = Quiz.all.published

        render json: @quizzes
      end

      def show
        @quiz = Quiz.find(params[:id])
        @author = @quiz.author
        @combination = {quiz: @quiz, author: @author}
        render json: @combination
      end

      def create
        @quiz = Quiz.new(quiz_params)

        if @quiz.save
          render json: @quiz, status: :created
        else
          render json: @quiz.errors, status: :unprocessable_entity
        end
      end

      def solve

        #ログインしているときの処理
        @quiz_status = QuizStatus.new(user_id: current_user.id, quiz_id: params[:id])

        if @quiz_status.save
          @queries = Quiz.find_by(id: params[:id]).queries
          @combination = {quiz_status: @quiz_status, queries: @queries}
          render json: @combination
        else
          render json: @quiz_status.errors, status: :unprocessable_entity
        end

      end

      def show_my_quizzes
        # draftedとpublishedをそれぞれグループ化してクライアントに返す。
        @my_quizzes = current_user.my_quizzes.to_a.group_by{ |quiz| quiz.published }
        render json: @my_quizzes
      end

      private

        #current_userを使っているため、authorize_access_request!メソッドにより予めpayloadがセットする。
        def quiz_params
          params.require(:quiz).permit(:title, :question, :answer, :diffculity).merge(user_id: current_user.id)
        end

    end
  end
end
