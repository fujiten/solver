# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show]
      before_action :authorize_access_request!, only: [:update, :show_mypage]

      def show
        @json = { user: @user, avatar: @user.avatar.encode(:icon) }
        render json: @json
      end

      def update
        @user = current_user
        @avatar = current_user.avatar

        @user.assign_attributes(user_params)
        image_file = ImageEncodable.decode_to_imagefile(avatar_params[:image])
        @avatar.assign_attributes(image: image_file)

        # 一つのモデルに集約が必要(Issue#11)
        if @user.valid? && @avatar.valid?
          if @user.save && @avatar.save
            render json: { user: @user, avatar: @avatar.encode(:icon) }
          else
            render json: { error: @user.errors.full_messages + @avatar.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: @user.errors.full_messages + @avatar.errors.full_messages }, status: :unprocessable_entity
        end

      end

      def show_me
        ac_token = request.cookies['ac_token']
        request.headers['Authorization'] = "Bearer #{ac_token}"

        response.set_cookie("signedIn",
        value: nil,
        domain: ENV["BASE_DOMAIN"],
        path: "/",
        secure: Rails.env.production?)

        authorize_access_request!

        response.set_cookie("ac_token",
        value: nil,
        domain: ENV["BASE_DOMAIN"],
        path: "/",
        secure: Rails.env.production?)

        response.set_cookie(JWTSessions.access_cookie,
        value: request.cookies["ac_token"],
        httponly: true,
        secure: Rails.env.production?)

        render json: { csrf: request.cookies["csrf"],
                       my_avatar: current_user.avatar.encode(:icon),
                       uid: current_user.id  }
      end

      def show_mypage

        # draftedとpublishedをそれぞれグループ化してクライアントに返す。
        @my_quizzes = current_user.my_quizzes.group_by { |quiz| quiz.published }

        @grouped_my_quiz_statuses = QuizStatus.where(user_id: current_user.id).includes(:quiz)
        @trying_quizzes = @grouped_my_quiz_statuses.where(be_solved: false).map { |status| status.quiz }
        @solved_quizzes = @grouped_my_quiz_statuses.where(be_solved: true).map { |status| status.quiz }

        @json = { my_quizzes: @my_quizzes,
                  trying_quizzes: @trying_quizzes,
                  solved_quizzes: @solved_quizzes,
                  current_user: current_user,
                  avatar: current_user.avatar.encode(:icon)
                }

        render json: @json
      end

      private

        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(:name, :description)
        end

        def avatar_params
          params.require(:avatar).permit(:image)
        end

    end
  end
end
