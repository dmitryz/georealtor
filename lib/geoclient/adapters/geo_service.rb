require 'geoclient/errors'

module Geoclient
  module Adapters
    class GeoService
      class << self
        attr_accessor :url

        def default_settings
          OpenStruct.new(url: url).freeze
        end
      end

      def initialize(settings = GeoService.default_settings)
        @settings = settings
        @address = address
      end

      def locate(address)
        begin
          response = send_request('address', address)
        rescue Faraday::Error::ConnectionFailed => e
          raise Geoclient::ConnectionError, "Connection failed"
        end
        data = validate_result!(response)
        data
      end

    private

      def send_request(method, query)
        connection.get do |request|
          request.headers["Content-Type"] = "application/json"
          request.params[method] = query
        end
      end

      def validate_result!(response)
        raise Geocoder::Error, "#{response.status}: #{response.reason_phrase}" unless response.status == 200

        hash = JSON.parse(response.body)
        raise Geocoder::Error, "Not found formatted address" unless hash.dig(:data, :formatted_address)
        raise Geocoder::Error, "Not found formatted address" unless hash.dig(:data, :formatted_address, :address_components)
        hash
      end

      def connection
        @connection ||= Faraday.new(url: @settings.url)
      end
    end
  end
end
