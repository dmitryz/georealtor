require 'rails_helper'
require 'geoclient/resolver'
require 'prices_client/resolver'

ADDRESS_IDS = { 'city' => '80969793-feec-45f6-9cb4-922068d7e2af',
                'zip_code' => 'a8044367-5fde-41cf-ab36-3ef3ed50d68c' }
GEO_SERVICE_URL = "http://geoclient.com/geo"
PRICE_SERVICE_URL = "http://geoprice.com/price"
BASE_FIXT_PATH = "spec/fixtures/prices_client/"

describe Estimate::AddressesController do
  let(:geoclient_checkpoint_charly) { File.read('spec/fixtures/geoclient/geo_service_checkpoint_charly.json') }

  before do
    Geoclient::Adapters::GeoService.url = GEO_SERVICE_URL
    PricesClient::Adapters::PriceService.url = PRICE_SERVICE_URL

    stub_request(:get, "#{GEO_SERVICE_URL}?address=Checkpoint%20charly").
      to_return(status: 200,
                body: geoclient_checkpoint_charly,
                headers: {"Content-Type"=> "application/json"})

    stub_price_request('sell', 'house',     'city')
    stub_price_request('sell', 'apartment', 'city')
    stub_price_request('rent', 'house',     'city')
    stub_price_request('rent', 'apartment', 'city')
    stub_price_request('sell', 'house',     'zip_code')
    stub_price_request('sell', 'apartment', 'zip_code')
    stub_price_request('rent', 'house',     'zip_code')
    stub_price_request('rent', 'apartment', 'zip_code')
  end

  describe "when address is real" do
    it "should estimate the prices" do
      process :search, method: :get, params: { query: 'Checkpoint charly' }
      expect(response.response_code).to eq(200)
    end
  end

  def stub_price_request(marketing_type, property_type, type, address_id=nil)
    address_id = ADDRESS_IDS[type]
    body = File.read("#{BASE_FIXT_PATH}/#{property_type}_#{marketing_type}_#{type}_b3e770f9.json")
    params = "id=#{address_id}&marketing_type=#{marketing_type}&property_type=#{property_type}&type=#{type}"
    stub_request(:get, "#{PRICE_SERVICE_URL}?#{params}").
      to_return(status: 200,
                body: body,
                headers: {"Content-Type"=> "application/json"})

  end
end

