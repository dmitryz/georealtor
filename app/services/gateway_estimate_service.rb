require 'geoclient/resolver'
require 'prices_client/resolver'
require 'estimate/error'

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

    prices_count = 0
    geo_data.address_components.each do |address|
      sales = get_prices(address.id, address.type)
      rent = get_rent(address.id, address.type) 

      next if sales.empty? && rent.empty?

      result[address.type] =  {}.tap do |data| 
        data[:name] = address.name
        data[:prices] = {}.tap do |price|
          price[:sales] = sales if sales.present?
          price[:rent] = rent if rent.present?
        end
      end
      prices_count += 1
    end

    raise GatewayNoAnyPrice if prices_count == 0
    result
  end

  private

  def get_prices(id, type)
    marketing_type = 'sell'
    house_price = begin
      prices_client.call(id: id, marketing_type: marketing_type, property_type: 'house', type: type)
    rescue PricesClient::Error
      nil
    end

    apartment_price = begin
      prices_client.call(id: id, marketing_type: marketing_type, property_type: 'apartment', type: type)
    rescue PricesClient::Error
      nil
    end

    {}.tap do |data|
      data[:house] = house_price if house_price
      data[:apartment] = apartment_price if apartment_price
    end
  end

  def get_rent(id, type)
    marketing_type = 'rent'
    house_rent = begin
      prices_client.call(id: id, marketing_type: marketing_type, property_type: 'house', type: type)
    rescue PricesClient::Error
      nil
    end

    apartment_rent = begin
      prices_client.call(id: id, marketing_type: marketing_type, property_type: 'apartment', type: type)
    rescue PricesClient::Error
      nil
    end

    {}.tap do |data|
      data[:house] = house_rent if house_rent
      data[:apartment] = apartment_rent if apartment_rent
    end
  end

  attr_reader :address, :geoclient, :prices_client
end
