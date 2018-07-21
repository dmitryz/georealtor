require 'geoclient/adapters/geo_service'

module Geoclient
  class Resolver
    def initialize(adapter: Geoclient::Adapters::GeoService.new)
      @adapter = adapter
    end

    def call(address)
      data = adapter.locate(address)
      get_components(data)
    end

  private
    def get_components(data)
        address_components = data['data']['address_components'].dup
        address_components.reject! { |hash| hash['id'].nil? }
        address_components.map { |hash| OpenStruct.new(id: hash['id'], type: hash['type']) }
    end

    attr_reader :adapter, :data
  end
end
