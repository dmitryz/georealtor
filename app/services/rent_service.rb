# frozen_string_literal: true

require 'prices_client/resolver'

# RentService
class RentService
  include BaseService

  def initialize(id, type, prices_client = PricesClient::Resolver.new)
    @id = id
    @type = type
    @prices_client = prices_client
  end

  def call
    get_rent(@id, @type)
  end

  private

  def get_rent(id, type)
    marketing_type = 'rent'
    house_rent = get_house_rent(id, type, marketing_type)
    apartment_rent = get_apartment_price(id, type, marketing_type)

    {}.tap do |data|
      data[:house] = house_rent if house_rent
      data[:apartment] = apartment_rent if apartment_rent
    end
  end

  def get_house_rent(id, type, marketing_type)
    prices_client.call(id: id,
                       marketing_type: marketing_type,
                       property_type: 'house', type: type)
  rescue PricesClient::Error
    nil
  end

  def get_apartment_price(id, type, marketing_type)
    prices_client.call(id: id,
                       marketing_type: marketing_type,
                       property_type: 'apartment', type: type)
  rescue PricesClient::Error
    nil
  end

  attr_reader :id, :type, :prices_client
end
