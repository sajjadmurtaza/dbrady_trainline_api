# frozen_string_literal: true

require 'json'
require 'httparty'

# The TrainlineService class provides methods for interacting with the Trainline API.
class TrainlineService
  include HTTParty

  base_uri 'https://www.thetrainline.com/api'
  TOKEN = 'YOUR_TOKEN_HERE'

  JSON_RESPONSE_FILE = Rails.root.join('public', 'data.json')

  def initialize
    @access_token = TOKEN
  end

  def find_journeys(payload)
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{@access_token}"
    }

    response = self.class.post('/journey-search/', body: payload.to_json, headers: headers)
    JSON.parse(response.body)
  end

  # Reads and parses a JSON file containing journey data. return [Hash, nil] The parsed JSON data as a hash, or nil.
  def self.read_journey_data_from_file
    return unless File.exist?(JSON_RESPONSE_FILE)

    begin
      json_data = File.read(JSON_RESPONSE_FILE)
      JSON.parse(json_data)
    rescue JSON::ParserError => e
      Rails.logger.error "Error parsing JSON: #{e.message}"
      nil
    end
  end
end
