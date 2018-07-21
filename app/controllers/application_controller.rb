# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  require 'estimate/error'
  require 'geoclient/errors'
  require 'prices_client/errors'

  rescue_from Geoclient::ApiError do |error|
    render json: { errors: error }, status: :unprocessable_entity
  end

  rescue_from Geoclient::Error do |error|
    render json: { error: error }, status: :unprocessable_entity
  end

  rescue_from GatewayNoAnyPrice do |_error|
    render json: { error: 'No any price were found' },
           status: :unprocessable_entity
  end

  rescue_from Faraday::Error::ConnectionFailed do |_error|
    render json: { error: 'Connection failed' }, status: :bad_gateway
  end
end
