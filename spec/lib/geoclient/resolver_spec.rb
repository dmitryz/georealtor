# frozen_string_literal: true

require 'rails_helper'
require 'geoclient/resolver'

describe Geoclient::Resolver do
  let(:service) { described_class.new(adapter: geo_service_adapter) }
  let(:geo_service_adapter) { instance_double(Geoclient::Adapters::GeoService) }
  let(:geoclient_checkpoint_charly) do
    JSON.parse(File.read("#{GC_BASE_PATH}/geo_service_checkpoint_charly.json"))
  end

  # rubocop:disable Metrics/LineLength
  before do
    allow(geo_service_adapter).to receive(:locate).and_return(geoclient_checkpoint_charly)
  end
  # rubocop:enable Metrics/LineLength

  describe 'when Geoclient was called' do
    subject! { service.call('Checkpoint charly') }

    it 'returns location' do
      is_expected.to be_a_kind_of OpenStruct
    end
  end
end
