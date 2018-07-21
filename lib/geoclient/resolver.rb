require 'geoclient/adapters/geo_service'

module Geoclient
  class Resolver
    def initialize(adapter: Geoclient::Adapters::GeoService.new)
      @adapter = adapter
    end

    def call(address)
      adapter.locate(address)
    end

  private
    attr_reader :adapter
  end
end
