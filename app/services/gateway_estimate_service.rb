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
    address_components = geoclient.call(address)['data']['address_components']
    address_components.map { |hash| OpenStruct.new(id: hash['id'], type: hash['type']) }
    end
  end

  private

  attr_reader :address, :geoclient, :prices_client
end
