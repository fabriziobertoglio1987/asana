class Api::V1::LocationsController < ApplicationController
  before_action :authenticate_user
  rescue_from Geocoder::OverQueryLimitError,
    :with => :render_geocoder_limit_reached

  def index
    location = Geocoder.search(params[:address]).first
    if location
      render json: { location: { latitude: location.data['lat'], longitude: location.data['lon'] }}, status: 200
    else
      render json: { errors: ['Location not found']}, status: 404
    end
  end
  
  private 
  def authenticate_user
    render_unauthorized unless find_user
  end

  def render_geocoder_limit_reached
    render json: { errors: ["Geocoder API daily limit reached"] }, status: 200
  end

  def find_user
    @user = User.find_by(id: decode.first['user_id'])
  end
end
