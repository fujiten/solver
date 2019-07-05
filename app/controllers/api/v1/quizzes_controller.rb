module Api 
  module V1
    class QuizzesController < ApplicationController
      before_action :set_quiz, only: [:show] 
      before_action :authorize_access_request!, only: [:create, :update, :destroy, :solve, :update_quiz_status, :show_my_quizzes]
      
      def index
        @quizzes = Quiz.all.published

        render json: @quizzes
      end

      def show
        @author = @quiz.author
        @combination = {quiz: @quiz, author: @author}

        #「ログインしてない場合」はrescueで回収して[:isOthers]（他人クイズ）フラグを立てる。
        #「ログインしている場合」については、条件分岐する。
        # （あとでモデル層に処理を委譲します。) 
        # access_expireが切れていた場合、isOthersフラグが立ってしまう不具合要修正
        begin
          authorize_access_request!
          if @author.id == payload['user_id']
            @combination[:isMine] = true
          else
            @quiz_status = QuizStatus.find_by(quiz_id: @quiz.id, user_id: payload['user_id'])
            @combination[:quiz_status] = @quiz_status
            @done_queries = @quiz_status&.done_queries 
            @combination[:done_queries] = @done_queries
            @combination[:isOthers] = true
          end
        rescue JWTSessions::Errors::Unauthorized
          @combination[:isOthers] = true
        end
        render json: @combination
      end

      def create
        @quiz = Quiz.new(quiz_params)

        if @quiz.save
          render json: @quiz, status: :created
        else
          render json: { error: @quiz.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @quiz = current_user.my_quizzes.find(params[:id])
        if @quiz.update(quiz_params)
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
          params.fetch(:quiz, {}).permit(:title, :question, :answer, :diffculity, :published).merge(user_id: current_user.id)
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
