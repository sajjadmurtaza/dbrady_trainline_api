# frozen_string_literal: true

# spec/controllers/api/v1/travel_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::TravelController, type: :controller do
  describe 'GET #find_trip_options' do
    it 'returns unprocessable_entity status with invalid parameters' do
      invalid_params = { from: 'London', to: 'Paris', departure_at: 'invalid_datetime' }

      get :find_trip_options, params: invalid_params

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns unprocessable_entity status when TrainlineService raises an error' do
      allow_any_instance_of(TrainlineService).to receive(:find_journeys).and_raise(StandardError, 'API Error')

      get :find_trip_options

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #find_trip_options_by_hardcoded_json' do
    it 'returns a successful response' do
      get :find_trip_options_by_hardcoded_json

      expect(response).to have_http_status(:success)
    end

    it 'calls read_journey_data_from_file on TrainlineService' do
      get :find_trip_options_by_hardcoded_json
    end
  end
end
