require 'rails_helper'
require 'prices_client/resolver'

ADDRESS_ID = '80969793-feec-45f6-9cb4-922068d7e2af'

describe PricesClient::Resolver do
  let(:service) { described_class.new(adapter: price_service_adapter) }
  let(:price_service_adapter) { instance_double(PricesClient::Adapters::PriceService) }
  let(:house_sell_city) { JSON.parse(File.read('spec/fixtures/prices_client/house_sell_city_b3e770f9.json')) }
  let(:house_sell_zip_code) { JSON.parse(File.read('spec/fixtures/prices_client/house_sell_zip_code_b3e770f9.json')) }
  let(:apartment_rent_city) { JSON.parse(File.read('spec/fixtures/prices_client/apartment_rent_city_b3e770f9.json')) }
  let(:apartment_rent_zip_code) { JSON.parse(File.read('spec/fixtures/prices_client/apartment_rent_zip_code_b3e770f9.json')) }

  before do
    allow(price_service_adapter).to receive(:estimate).with(
                                            type: 'city',
                                            id: ADDRESS_ID,
                                            marketing_type: 'sell',
                                            property_type: 'house'
                                           ).and_return(house_sell_city)
  end

  [%w{house sell city}, %w{house sell zip_code}, %w{apartment rent city}, %w{apartment rent zip_code}].each do |params|

    describe "when PricesClient was called with: #{params[0]}, #{params[1]}, #{params[2]}" do
      before do
        allow(price_service_adapter).to receive(:estimate).
          with(type: params[2], id: ADDRESS_ID, marketing_type: params[1], property_type: params[0]).
          and_return(eval([params[0], params[1], params[2]].join('_')))
      end

      subject! { service.call(type: params[2], 
                              id: ADDRESS_ID,
                              marketing_type: params[1],
                              property_type: params[0]
                             ) }

      it "returns estimation" do
        is_expected.to be_a_kind_of Float
      end
    end
  end
end
