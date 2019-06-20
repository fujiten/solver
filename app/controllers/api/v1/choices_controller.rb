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
          render json: @choice.errors, status: :unprocessable_entity
        end
        
      end

      private

        def choice_params
          params.required(:choice).permit(:body, :correctness)
        end


    end
  end
end
