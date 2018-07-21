# frozen_string_literal: true

require 'prices_client/resolver'

# PriceService
class PriceService
  include BaseService

  def initialize(id, type, prices_client = PricesClient::Resolver.new)
    @id = id
    @type = type
    @prices_client = prices_client
  end

  def call
    get_prices(@id, @type)
  end

  private

  def get_prices(id, type)
    marketing_type = 'sell'

    house_price = get_house_price(id, marketing_type, type)
    apartment_price = get_apartment_price(id, marketing_type, type)

    {}.tap do |data|
      data[:house] = house_price if house_price
      data[:apartment] = apartment_price if apartment_price
    end
  end

  def get_house_price(id, marketing_type, type)
    prices_client.call(id: id,
                       marketing_type: marketing_type,
                       property_type: 'house', type: type)
  rescue PricesClient::Error
    nil
  end

  def get_apartment_price(id, marketing_type, type)
    prices_client.call(id: id,
                       marketing_type:
                       marketing_type, property_type: 'apartment', type: type)
  rescue PricesClient::Error
    nil
  end

  attr_reader :id, :type, :prices_client
end
