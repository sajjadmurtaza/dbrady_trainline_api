# frozen_string_literal: true

module Api
  module V1
    class TravelController < ApplicationController
      before_action :set_trainline_service, only: [:find_trip_options]
      rescue_from StandardError, with: :render_error_response

      def find_trip_options
        trip_data = @trainline_service.find_trip_options(trip_params)

        render_segments(trip_data)
      end

      def find_trip_options_by_hardcoded_json
        trip_data = TrainlineService.read_journey_data_from_file

        render_segments(trip_data)
      end

      private

      def set_trainline_service
        @trainline_service = TrainlineService.new
      end

      def trip_params
        params.permit(:from, :to, :departure_at)
      end

      def render_segments(trip_data)
        segments = TrainlineDataParser.extract_segments(trip_data)

        render json: segments
      end

      def render_error_response(error)
        render json: { error: error.message }, status: :unprocessable_entity
      end
    end
  end
end
