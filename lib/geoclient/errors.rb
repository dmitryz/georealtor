require 'geoclient/adapters/geo_service'

module Geoclient
  class Error < StandardError; end
  class ApiError < StandardError; end
  class ConnectionError < StandardError; end
end
