class Estimate::AddressesController < ApplicationController
  EXPIRE_SEARCH = 1.hour

  def search
    hash = Rails.cache.fetch('posts/'+params[:query], expires_in: EXPIRE_SEARCH) do
      GatewayEstimateService.call(params[:query])
    end
    render json: hash.as_json
  end
end
