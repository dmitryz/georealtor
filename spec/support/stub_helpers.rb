# frozen_string_literal: true

module StubHelpers
  ADDRESS_IDS = { 'city' => '80969793-feec-45f6-9cb4-922068d7e2af',
                  'zip_code' => 'a8044367-5fde-41cf-ab36-3ef3ed50d68c' }.freeze

  PC_BASE_PATH = 'spec/fixtures/prices_client/'
  GC_BASE_PATH = 'spec/fixtures/geoclient/'
  ES_BASE_PATH = 'spec/fixtures/estimate/'

  def build_params(marketing_type, property_type, type)
    address_id = ADDRESS_IDS[type]
    "id=#{address_id}&marketing_type=#{marketing_type}&property_type=#{property_type}&type=#{type}"
  end

  def stub_geo_service_request
    stub_request(:get, "#{GEO_SERVICE_URL}?address=Checkpoint%20charly")
      .to_return(status: 200,
                 body: geoclient_checkpoint_charly,
                 headers: { 'Content-Type' => 'application/json' })
  end

  def stub_geo_service_request_error(address = 'Checkpoint%20charly')
    stub_request(:get, "#{GEO_SERVICE_URL}?address=#{address}")
      .to_return(status: 200,
                 body: geoclient_error,
                 headers: { 'Content-Type' => 'application/json' })
  end

  def stub_price_request_error(marketing_type, property_type, type)
    body = File.read("#{PC_BASE_PATH}/error.json")
    params = build_params(marketing_type, property_type, type)
    stub_request(:get, "#{PRICE_SERVICE_URL}?#{params}")
      .to_return(status: 200,
                 body: body,
                 headers: { 'Content-Type' => 'application/json' })
  end

  def stub_price_request(marketing_type, property_type, type)
    params = build_params(marketing_type, property_type, type)
    body = File.read("#{PC_BASE_PATH}/#{property_type}_#{marketing_type}_#{type}_b3e770f9.json")
    stub_request(:get, "#{PRICE_SERVICE_URL}?#{params}")
      .to_return(status: 200,
                 body: body,
                 headers: { 'Content-Type' => 'application/json' })
  end
end
