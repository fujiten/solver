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

        #「ログインしてない場合」はrescueで回収して[:isOthers]（他人クイズ）フラグを立てる。
        #「ログインしている場合」については、条件分岐する。
        # （あとでモデル層に処理を委譲します。) 
        # access_expireが切れていた場合、isOthersフラグが立ってしまう不具合要修正
        begin
          authorize_access_request!
          if @author.id == payload['user_id']
            @combination[:isMine] = true
          else
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
          render json: @quiz.errors, status: :unprocessable_entity
        end
      end

      def solve

        #ログインしているときの処理
        p current_user
        @quiz_status = QuizStatus.new(user_id: current_user.id, quiz_id: params[:id])

        if @quiz_status.save
          @queries = Quiz.find_by(id: params[:id]).queries
          @combination = {quiz_status: @quiz_status, queries: @queries}
          render json: @combination
        else
          render json: @quiz_status.errors, status: :unprocessable_entity
        end

      end

      private

        #current_userを使っているため、authorize_access_request!メソッドにより予めpayloadをする必要あり。
        def quiz_params
          params.require(:quiz).permit(:title, :question, :answer, :diffculity).merge(user_id: current_user.id)
        end

    end
  end
end
