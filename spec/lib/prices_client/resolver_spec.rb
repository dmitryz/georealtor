# frozen_string_literal: true

require 'rails_helper'
require 'prices_client/resolver'

ADDRESS_ID = '80969793-feec-45f6-9cb4-922068d7e2af'
FIXT_BASE_PATH = 'spec/fixtures/prices_client/'

# rubocop:disable Metrics/BlockLength
describe PricesClient::Resolver do
  let(:service) { described_class.new(adapter: price_service_adapter) }
  let(:price_service_adapter) do
    instance_double(PricesClient::Adapters::PriceService)
  end

  [%w[house sell city],
   %w[house sell zip_code],
   %w[apartment rent city],
   %w[apartment rent zip_code]].each do |params|

    describe "when PricesClient was called with: #{params.join(', ')}" do
      before do
        fixt_path = FIXT_BASE_PATH + params.join('_') + '_b3e770f9.json'
        allow(price_service_adapter).to receive(:estimate)
          .with(type: params[2],
                id: ADDRESS_ID,
                marketing_type: params[1],
                property_type: params[0])
          .and_return(JSON.parse(File.read(fixt_path)))
      end

      subject! do
        service.call(type: params[2],
                     id: ADDRESS_ID,
                     marketing_type: params[1],
                     property_type: params[0])
      end

      it 'returns estimation' do
        is_expected.to be_a_kind_of Float
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
