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

  rescue_from GatewayNoAnyPrice do |error|
    render json: { error: "No any price were found" }, status: :unprocessable_entity
  end

  rescue_from Faraday::Error::ConnectionFailed do |error|
    render json: { error: "Connection failed" }, status: :bad_gateway
  end

end
