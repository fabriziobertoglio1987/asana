class Api::V1::LocationsController < ApplicationController
  before_action :authenticate_user

  def index
    location = Geocoder.search(params[:address]).first
    if location
      render json: { location: { latitude: location.data['lat'], longitude: location.data['lon'] }}, status: 200
    else
      render json: { errors: ['Location not found']}, status: 200
    end
  end
  
  private 
  def authenticate_user
    render_unauthorized unless find_user
  end

  def render_unauthorized
    render json: { errors: ["Unauthorized, include the correct authentication token in the request header."] }, status: 401
  end

  def find_user
    @user = User.find_by(id: decode.first['user_id'])
  end
end
