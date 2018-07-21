require 'prices_client/adapters/price_service'

module PricesClient
  class Resolver
    def initialize(adapter: PricesClient::Adapters::PriceService.new)
      @adapter = adapter
    end

    def call(type:, id:, marketing_type:, property_type:)
      adapter.estimate(type: type, id: id, marketing_type: marketing_type, property_type: property_type)
    end

  private
    attr_reader :adapter
  end
end
