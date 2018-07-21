# frozen_string_literal: true

require 'rails_helper'
require 'geoclient/resolver'
require 'prices_client/resolver'

GEO_SERVICE_URL = 'http://geoclient.com/geo'
PRICE_SERVICE_URL = 'http://geoprice.com/price'
ES_BASE_PATH = 'spec/fixtures/estimate/'
GC_BASE_PATH = 'spec/fixtures/geoclient/'

# rubocop:disable Metrics/BlockLength
describe Estimate::AddressesController do
  let(:geoclient_checkpoint_charly) do
    File.read("#{GC_BASE_PATH}/geo_service_checkpoint_charly.json")
  end
  let(:geoclient_error) { File.read("#{GC_BASE_PATH}/error.json") }
  let(:estimate_address_success) do
    JSON.parse(File.read("#{ES_BASE_PATH}/success.json"))
  end
  let(:one_price_estimate_address_success) do
    JSON.parse(File.read("#{ES_BASE_PATH}/one_price_success.json"))
  end

  before do
    Geoclient::Adapters::GeoService.url = GEO_SERVICE_URL
    PricesClient::Adapters::PriceService.url = PRICE_SERVICE_URL
  end

  describe 'when address is real' do
    before do
      stub_geo_service_request
    end

    describe 'and all prices were found' do
      before do
        stub_price_request('sell', 'house',     'city')
        stub_price_request('sell', 'apartment', 'city')
        stub_price_request('rent', 'house',     'city')
        stub_price_request('rent', 'apartment', 'city')
        stub_price_request('sell', 'house',     'zip_code')
        stub_price_request('sell', 'apartment', 'zip_code')
        stub_price_request('rent', 'house',     'zip_code')
        stub_price_request('rent', 'apartment', 'zip_code')
      end

      it 'should estimate the prices' do
        process :search, method: :get, params: { query: 'Checkpoint charly' }
        expect(JSON.parse(response.body)).to eq(estimate_address_success)
        expect(response.response_code).to eq(200)
      end
    end

    describe 'and at least one price was found' do
      before do
        stub_price_request('sell', 'house', 'city')
        stub_price_request_error('sell', 'apartment', 'city')
        stub_price_request_error('rent', 'house',     'city')
        stub_price_request_error('rent', 'apartment', 'city')
        stub_price_request_error('sell', 'house',     'zip_code')
        stub_price_request_error('sell', 'apartment', 'zip_code')
        stub_price_request_error('rent', 'house',     'zip_code')
        stub_price_request_error('rent', 'apartment', 'zip_code')
      end

      it 'should estimate the prices' do
        process :search, method: :get, params: { query: 'Checkpoint charly' }
        json_body = JSON.parse(response.body)
        expect(json_body).to eq(one_price_estimate_address_success)

        expect(response.response_code).to eq(200)
      end
    end

    describe 'and no any price were found' do
      before do
        stub_price_request_error('sell', 'house',     'city')
        stub_price_request_error('sell', 'apartment', 'city')
        stub_price_request_error('rent', 'house',     'city')
        stub_price_request_error('rent', 'apartment', 'city')
        stub_price_request_error('sell', 'house',     'zip_code')
        stub_price_request_error('sell', 'apartment', 'zip_code')
        stub_price_request_error('rent', 'house',     'zip_code')
        stub_price_request_error('rent', 'apartment', 'zip_code')
      end

      it 'should return error' do
        process :search, method: :get, params: { query: 'Checkpoint charly' }
        error = { 'error' => 'No any price were found' }
        expect(JSON.parse(response.body)).to eq(error)

        expect(response.response_code).to eq(422)
      end
    end
  end

  describe 'when address not found' do
    before do
      stub_geo_service_request_error('BBBBBBBB')
    end

    it 'should return error' do
      process :search, method: :get, params: { query: 'BBBBBBBB' }
      error = { 'errors' => 'Something went wrong' }
      expect(JSON.parse(response.body)).to eq(error)

      expect(response.response_code).to eq(422)
    end
  end
end
# rubocop:enable Metrics/BlockLength
