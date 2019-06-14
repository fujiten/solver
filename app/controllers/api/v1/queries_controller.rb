module Api 
  module V1
    class QueriesController < ApplicationController
      before_action :set_query, only: [:show, :update, :destroy]

      def index
        @queries = Query.where(quiz_id: params[:quiz_id])

        render json: @queries
      end

      def show
        render json: @query
      end

      def create
        @query = Query.new(query_params.merge(quiz_id: params[:quiz_id]))

        if @query.save
          render json: @query, status: :created
        else
          render json: @query.errors, status: :unprocessable_entity
        end
      end

      def update
        if @query.update(query_params)
          render json: @query
        else
          render json: @query.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @query.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_query
          @query = Query.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def query_params
          params.require(:query).permit(:category, :body, :answer, :revealed_point, :point)
        end

    end
  end
end
