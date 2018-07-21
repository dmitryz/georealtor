class Estimate::AddressesController < ApplicationController
  def search
    render json: GatewayEstimateService.call(params[:query]).as_json
  end
end
