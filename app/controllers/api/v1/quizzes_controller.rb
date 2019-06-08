module Api 
  module V1
    class QuizzesController < ApplicationController
      # before_action :set_quiz, only: [:show] 
      
      def index
        @quizzes = Quiz.all

        render json: @quizzes
      end

      def show
        @quiz = Quiz.includes(:queries).find(params[:id])
        @queries = @quiz.queries
        @quiz_status = QuizStatus.find_by(user_id: 1, quiz_id: params[:id])
        render json: [@quiz, @queries, @quiz_status]
      end

    end
  end
end
