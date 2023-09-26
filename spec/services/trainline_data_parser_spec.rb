# frozen_string_literal: true

# spec/trainline_data_parser_spec.rb
require 'spec_helper'

RSpec.describe TrainlineDataParser do
  let(:sample_data) { TrainlineService.read_journey_data_from_file }

  describe '.extract_segments' do
    it 'returns an array of trip options' do
      trip_options = TrainlineDataParser.extract_segments(sample_data)
      expect(trip_options).to be_an(Array)
      expect(trip_options).not_to be_empty
    end

    it 'correctly parses trip options' do
      trip_options = TrainlineDataParser.extract_segments(sample_data)
      expect(trip_options).to all(
        include(
          :departure_station,
          :departure_at,
          :arrival_station,
          :arrival_at,
          :service_agencies,
          :duration_in_minutes,
          :changeovers,
          :products,
          :fares
        )
      )
    end
  end

  describe '.location_name' do
    it 'returns the name of a location' do
      location_id = 'c3ef6b20d75ce01b807dc6824b30baf3e94fc520'
      location_name = TrainlineDataParser.location_name(sample_data, location_id)
      expect(location_name).to eq('Paris Gare du Nord')
    end
  end

  describe '.carrier_name' do
    it 'returns the name of a carrier' do
      carrier_id = 'd1333bfe5f7ddf352d5e84179cb00cc85be71cb4'
      carrier_name = TrainlineDataParser.carrier_name(sample_data, carrier_id)
      expect(carrier_name).to eq('Eurostar')
    end
  end

  describe '.parse_datetime' do
    it 'parses a datetime string' do
      datetime_str = '2023-09-24T10:30:00+00:00'
      datetime = TrainlineDataParser.parse_datetime(datetime_str)
      expect(datetime).to be_a(DateTime)
    end
  end

  describe '.iso8601_duration_to_minutes' do
    it 'converts ISO8601 duration to minutes' do
      duration = 'PT2H30M'
      minutes = TrainlineDataParser.iso8601_duration_to_minutes(duration)
      expect(minutes).to eq(150)
    end

    it 'returns nil for an invalid duration' do
      duration = 'invalid_duration'
      minutes = TrainlineDataParser.iso8601_duration_to_minutes(duration)
      expect(minutes).to be_nil
    end
  end

  describe '.find_full_price_and_currency' do
    it 'finds full price and currency' do
      fare_id = 'fare-331d4edd-143f-40cf-a8dc-e15700556c60'
      full_price, currency = TrainlineDataParser.find_full_price_and_currency(sample_data, fare_id)
      expect(full_price).to eq(354.44)
      expect(currency).to eq('USD')
    end

    it 'returns [nil, nil] when full price and currency are not found' do
      fare_id = 'non_existent_fare_id'
      full_price, currency = TrainlineDataParser.find_full_price_and_currency(sample_data, fare_id)
      expect(full_price).to be_nil
      expect(currency).to be_nil
    end
  end
end
