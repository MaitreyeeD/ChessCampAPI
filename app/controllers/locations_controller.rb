class LocationsController < ApplicationController
  # Controller Code
  swagger_controller :locations, "Locations Management"
  swagger_api :index do
    summary "Fetches all Locations"
    notes "This lists all the Locations"
  end

  swagger_api :show do
    summary "Shows one Location"
    param :path, :id, :integer, :required, "Location ID"
    notes "This lists details of one location"
    response :not_found
  end
  
  before_action :set_location, only: [:show]

  # GET /children
  def index
    @locations = Location.all

    render json: @locations
  end

  # GET /children/1
  def show
    render json: @location
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def location_params
      params.permit(:name, :street_1, :street_2, :city, :state, :zip, :max_capacity, :active)
    end
end
