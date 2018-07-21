require 'rails_helper'
require 'geoclient/resolver'

describe Geoclient::Resolver do
  let(:service) { described_class.new(adapter: geo_service_adapter) }
  let(:geo_service_adapter) { instance_double(Geoclient::Adapters::GeoService) }
  let(:geoclient_checkpoint_charly) { JSON.parse(File.read('spec/fixtures/geoclient/geo_service_checkpoint_charly.json')) }

  before do
    allow(geo_service_adapter).to receive(:locate).and_return(geoclient_checkpoint_charly)
  end

  describe "when Geoclient was called" do
    subject! { service.call("Checkpoint charly") }

    it "returns estimation" do
      is_expected.to be_a_kind_of Hash
    end
  end
end
