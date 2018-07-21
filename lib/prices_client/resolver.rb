# frozen_string_literal: true

require 'prices_client/adapters/price_service'

module PricesClient
  class Resolver
    def initialize(adapter: PricesClient::Adapters::PriceService.new)
      @adapter = adapter
    end

    def call(type:, id:, marketing_type:, property_type:)
      data = adapter.estimate(type: type, id: id, marketing_type: marketing_type, property_type: property_type)
      get_price(data)
    end

    private

    def get_price(data)
      data['data']['attributes']['price'].to_f
    end

    attr_reader :adapter
  end
end
