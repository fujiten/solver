module Api 
  module V1
    class QuizzesController < ApplicationController
      before_action :set_quiz, only: [:show] 
      
      def index
        @quizzes = Quiz.all

        render json: @quizzes
      end

      def show
        render json: @quiz
      end

      private

       def set_quiz
        @quiz = Quiz.find(params[:id])
       end

    end
  end
end
