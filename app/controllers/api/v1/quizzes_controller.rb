# frozen_string_literal: true

module Api
  module V1
    class QuizzesController < ApplicationController
      before_action :authorize_access_request!, only: [:create, :update, :show_quiz_status, :destroy, :solve, :update_quiz_status, :show_my_quizzes]
      before_action :set_quiz, only: [:show, :show_quiz_status]

      def index
        @quizzes = Quiz.all.published.includes(author: :avatar)
        @json = Quiz.arrange_quizzes(@quizzes)
        p 123
        render json: @json
      end

      def show
        @json = { quiz: @quiz.arrange_me_and_fetch_associations }

        render json: @json
      end

      def show_quiz_status
        @quiz_status = QuizStatus.find_by(quiz_id: @quiz.id, user_id: payload["user_id"])
        @json = { quiz_status: @quiz_status }
        if !@quiz_status.nil?
          @done_queries = @quiz_status.done_queries
          @json[:queries] = @queries
          @json[:done_queries] = @done_queries
        end
        render json: @json
      end

      def create
        @quiz = Quiz.new(quiz_params.merge(image: nil))

        if @quiz.save
          render json: @quiz, status: :created
        else
          render json: { error: @quiz.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @quiz = current_user.my_quizzes.find(params[:id])

        if quiz_params[:image]
          update_params = quiz_params.merge({image: ImageEncodable.decode_to_imagefile(quiz_params[:image])})
        else
          update_params = quiz_params
        end

        if @quiz.update(update_params)
          render json: @quiz
        else
          render json: @quiz.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @quiz = current_user.my_quizzes.find(params[:id])
        if @quiz.destroy
          render json: @quiz
        else
          render json: @quiz.errors, status: :unprocessable_entity
        end
      end

      def solve

        @quiz_status = QuizStatus.new(user_id: current_user.id, quiz_id: params[:id])

        if @quiz_status.save
          @queries = Quiz.find(params[:id]).queries
          @json = {quiz_status: @quiz_status, queries: @queries}
          render json: @json
        else
          render json: @quiz_status.errors, status: :unprocessable_entity
        end

      end

      def update_quiz_status
        @quiz_status = QuizStatus.find_by(user_id: current_user.id, quiz_id: params[:id])

        if params[:increment]
          @quiz_status.failed_answer_times += 1
        end

        if @quiz_status.update(quiz_status_params)
          render json: @quiz_status
        else
          render json: @quiz_status.error, status: :unprocessable_entity
        end

      end

      private

        #current_userを使っているため、authorize_access_request!メソッドにより予めpayloadをする必要あり。
        def quiz_params
          params.fetch(:quiz, {}).permit(:title, :question, :answer, :diffculity, :published, :image).merge(user_id: current_user.id)
        end

        def quiz_status_params
          params.require(:quiz_status).permit(:total_points, :query_times, :be_solved)
        end

        def set_quiz
          @quiz = Quiz.find(params[:id])
        end

    end
  end
end
