# frozen_string_literal: true

require 'prices_client/resolver'

PricesClient::Adapters::PriceService.url = ENV['PRICES_SERVICE_URL']
