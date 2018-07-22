# frozen_string_literal: true

require 'geoclient/errors'

module Geoclient
  module Adapters
    # GeoService
    class GeoService
      class << self
        attr_accessor :url

        def default_settings
          OpenStruct.new(url: url).freeze
        end
      end

      def initialize(settings = GeoService.default_settings)
        @settings = settings
      end

      def locate(address)
        begin
          response = send_request('address', address)
        rescue Faraday::Error::ConnectionFailed
          raise Geoclient::ConnectionError, 'Connection failed'
        end
        data = validate_result!(response)
        data
      end

      private

      def send_request(method, query)
        connection.get do |request|
          request.headers['Content-Type'] = 'application/json'
          request.params[method] = query
        end
      end

      # rubocop:disable Metrics/AbcSize, Metrics/LineLength
      def validate_result!(response)
        raise Geoclient::Error, "#{response.status}: #{response.reason_phrase}" unless response.status == 200

        hash = JSON.parse(response.body)
        raise Geoclient::ApiError, hash['errors'].join(', ') if hash['errors']
        raise Geoclient::Error, 'Not found formatted address' unless hash.dig('data', 'formatted_address')
        raise Geoclient::Error, 'Not found address component' unless hash.dig('data', 'address_components')
        hash
      end
      # rubocop:enable Metrics/AbcSize, Metrics/LineLength

      def connection
        @connection ||= Faraday.new(url: @settings.url)
      end
    end
  end
end
