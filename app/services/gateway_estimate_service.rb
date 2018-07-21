# frozen_string_literal: true

require 'geoclient/resolver'
require 'prices_client/resolver'
require 'estimate/error'

# GatewayEstimateService
class GatewayEstimateService
  include BaseService

  def initialize(address)
    @address = address
    @geoclient = Geoclient::Resolver.new
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def call
    geo_data = geoclient.call(address)
    result = { address: geo_data.formatted_address }

    prices_count = 0
    geo_data.address_components.each do |address|
      sales = PriceService.call(address.id, address.type)
      rent = RentService.call(address.id, address.type)
      next if sales.empty? && rent.empty?

      result[address.type] = {}.tap do |data|
        data[:name] = address.name
        data[:prices] = {}.tap do |price|
          price[:sales] = sales if sales.present?
          price[:rent] = rent if rent.present?
        end
      end
      prices_count += 1
    end
    raise GatewayNoAnyPrice if prices_count.zero?
    result
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  attr_reader :address, :geoclient, :prices_client
end
