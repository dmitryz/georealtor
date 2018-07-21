require 'geoclient/resolver'
require 'prices_client/resolver'

class GatewayEstimateService
  include BaseService

  def initialize(address)
    @address = address
    @geoclient = Geoclient::Resolver.new
    @prices_client = PricesClient::Resolver.new
  end

  def call
    geo_data = geoclient.call(address)
    result = { address: geo_data.formatted_address }
    geo_data.address_components.each do |address|
      result[address.type] =  { name: address.name,
                                prices: {
                                  sales: get_prices(address.id, address.type),
                                  rent: get_rent(address.id, address.type)
                                }
                              }
    end
    result
  end

  private

  def get_prices(id, type)
    marketing_type = 'sell'
    house_price = prices_client.call(id: id, marketing_type: marketing_type, property_type: 'house', type: type)
    apartment_price = prices_client.call(id: id, marketing_type: marketing_type, property_type: 'apartment', type: type)
    { house: house_price, apartment: apartment_price }
  end

  def get_rent(id, type)
    marketing_type = 'rent'
    house_rent = prices_client.call(id: id, marketing_type: marketing_type, property_type: 'house', type: type)
    apartment_rent = prices_client.call(id: id, marketing_type: marketing_type, property_type: 'apartment', type: type)
    { house: house_rent, apartment: apartment_rent }
  end

  attr_reader :address, :geoclient, :prices_client
end
