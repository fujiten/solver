module Api 
  module V1
    class QuizzesController < ApplicationController
      
      def index
        @quizzes = Quiz.all

        render json: @quizzes
      end
      
    end
  end
end
