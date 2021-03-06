# frozen_string_literal: true

module Api
  module V1
    class ChoicesController < ApplicationController

      def index
        @choices = Choice.where(quiz_id: params[:quiz_id])

        render json: @choices
      end

      def create
        @choice = Choice.new(choice_params.merge(quiz_id: params[:quiz_id]))

        if @choice.save
          render json: @choice, status: :created
        else
          render json: { error: @choice.errors.full_messages }, status: :unprocessable_entity
        end

      end

      def update
        @choice = Choice.find(params[:id])
        if @choice.update(choice_params)
          render json: @choice
        else
          render json: @choice.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @choice = Choice.find(params[:id])
        if @choice.destroy
          render json: @choice
        else
          render json: @choice.errors, status: :unprocessable_entity
        end
      end

      private

        def choice_params
          params.fetch(:choice, {}).permit(:body, :correctness)
        end


    end
  end
end
