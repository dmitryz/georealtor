class Estimate::AddressesController < ApplicationController
  def search
    hash = Rails.cache.fetch('posts/'+params[:query]) do
      GatewayEstimateService.call(params[:query])
    end
    render json: hash.as_json
  end
end
