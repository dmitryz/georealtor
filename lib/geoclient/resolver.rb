# frozen_string_literal: true

require 'geoclient/adapters/geo_service'

module Geoclient
  # Resolver address
  class Resolver
    def initialize(adapter: Geoclient::Adapters::GeoService.new)
      @adapter = adapter
    end

    def call(address)
      data = adapter.locate(address)
      OpenStruct.new(formatted_address: get_address(data),
                     address_components: get_components(data))
    end

    private

    def get_address(data)
      data['data']['formatted_address']
    end

    def get_components(data)
      address_components = data['data']['address_components'].dup
      address_components.reject! { |hash| hash['id'].nil? }
      address_components.map do |hash|
        OpenStruct.new(id: hash['id'],
                       type: hash['type'],
                       name: hash['short_name'])
      end
    end

    attr_reader :adapter
  end
end
