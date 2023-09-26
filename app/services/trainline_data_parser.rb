# frozen_string_literal: true

require 'json'
require 'date'

# TrainlineDataParser is responsible for parsing Trainline data into a structured format.
class TrainlineDataParser
  FULL_PRICE_NOT_FOUND = [nil, nil].freeze

  def self.extract_segments(data)
    journey_search = data['data']['journeySearch']
    trip_options = []

    journey_search['journeys'].each do |_journey_id, journey_data|
      leg = journey_search['legs'][journey_data['legs'].first]
      trip_option = build_trip_option(data, journey_data, leg)
      trip_options << trip_option
    end

    trip_options
  end

  def self.build_trip_option(data, journey_data, leg)
    {
      departure_station: location_name(data, leg['departureLocation']),
      departure_at: parse_datetime(journey_data['departAt']),
      arrival_station: location_name(data, leg['arrivalLocation']),
      arrival_at: parse_datetime(journey_data['arriveAt']),
      service_agencies: carrier_name(data, leg['carrier']),
      duration_in_minutes: iso8601_duration_to_minutes(journey_data['duration']),
      changeovers: data['data']['journeySearch']['legs'].length - 1,
      products: ['train'],
      fares: ['See below']
    }.merge(fare_info(data, leg['id']))
  end

  def self.fare_info(data, leg_id)
    comfort_class = find_comfort_class(data, leg_id)
    fare_data = find_fare_data(data, leg_id)

    return {} unless comfort_class && fare_data

    fare_id = fare_data&.first
    fare_type = fare_data.last['fareType']
    fare_name = data['data']['fareTypes'][fare_type]['name']
    full_price, currency = find_full_price_and_currency(data, fare_id)
    price_in_cents = full_price&.to_f&.* 100

    {
      fares: [{
        name: fare_name,
        price_in_cents: price_in_cents,
        currency: currency,
        comfort_class: comfort_class
      }]
    }
  end

  def self.find_comfort_class(data, leg_id)
    fare_legs = data['data']['journeySearch']['fares'].values.flat_map { |fare| fare['fareLegs'] }
    fare_leg = fare_legs.find { |leg| leg['legId'] == leg_id }

    fare_leg&.dig('travelClass', 'name')
  end

  def self.find_fare_data(data, leg_id)
    data['data']['journeySearch']['fares'].find do |_fare_id, fare_details|
      fare_details['fareLegs'].any? { |fare_leg| fare_leg['legId'] == leg_id }
    end
  end

  def self.location_name(data, location_id)
    data['data']['locations'][location_id]['name']
  end

  def self.carrier_name(data, carrier_id)
    data['data']['carriers'][carrier_id]['name']
  end

  def self.parse_datetime(datetime_str)
    DateTime.parse(datetime_str)
  end

  def self.iso8601_duration_to_minutes(duration)
    match = duration.match(/PT(\d+)H(\d+)M/)
    return nil unless match

    hours = match[1].to_i
    minutes = match[2].to_i
    (hours * 60) + minutes
  end

  def self.find_full_price_and_currency(data, fare_id)
    data['data']['journeySearch']['alternatives'].each do |_, alternative_data|
      next unless alternative_data['fares'].include?(fare_id)

      full_price = alternative_data.dig('fullPrice', 'amount')
      currency = alternative_data.dig('fullPrice', 'currencyCode')
      return [full_price, currency]
    end

    FULL_PRICE_NOT_FOUND
  end
end
