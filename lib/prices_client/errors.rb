# frozen_string_literal: true

require 'prices_client/adapters/price_service'

module PricesClient
  class Error < StandardError; end
  class ConnectionError < StandardError; end
end
