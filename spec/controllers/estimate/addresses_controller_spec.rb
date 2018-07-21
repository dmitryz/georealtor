require 'rails_helper'

describe Estimate::AddressesController do
  describe "when address is real" do
    it "should estimate the prices" do
      process :search, method: :get, params: { query: 'Checkpoint charly' }
      expect(response.response_code).to eq(200)
    end
  end
end

