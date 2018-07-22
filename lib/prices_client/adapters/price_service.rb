# frozen_string_literal: true

require 'prices_client/errors'

module PricesClient
  module Adapters
    # PriceService adapter
    class PriceService
      class << self
        attr_accessor :url

        def default_settings
          OpenStruct.new(url: url).freeze
        end
      end

      def initialize(settings = PriceService.default_settings)
        @settings = settings
      end

      # rubocop:disable Metrics/MethodLength
      def estimate(type:, id:, marketing_type:, property_type:)
        begin
          params = { type: type,
                     id: id,
                     marketing_type: marketing_type,
                     property_type: property_type }
          response = send_request(params)
        rescue Faraday::Error::ConnectionFailed
          raise Geoclient::ConnectionError, 'Connection failed'
        end
        data = validate_result!(response)
        data
      end
      # rubocop:enable Metrics/MethodLength

      private

      def send_request(params)
        connection.get do |request|
          request.headers['Content-Type'] = 'application/json'
          request.params = params
        end
      end

      # rubocop:disable Metrics/LineLength
      def validate_result!(response)
        raise PricesClient::Error, "#{response.status}: #{response.reason_phrase}" unless response.status == 200

        hash = JSON.parse(response.body)
        raise PricesClient::Error, 'Not found attributes address' unless hash.dig('data', 'attributes')
        raise PricesClient::Error, 'Not found price' unless hash.dig('data', 'attributes', 'price')
        hash
      end
      # rubocop:enable Metrics/LineLength

      def connection
        @connection ||= Faraday.new(url: @settings.url)
      end
    end
  end
end
