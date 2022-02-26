class Api::V1::GeolocationsController < ApplicationController
  # before_action :set_geolocation, only: %i[show destroy]

  #-----------------------------------------------------------------------------
  # GET show /geolocations/:id
  #-----------------------------------------------------------------------------
  def show
    geolocation = ::Geolocations::Show.new
    geolocation.call(permitted_params) do |m|
      m.success do |response|
        render json: response, status: 201
      end

      m.failure do |response|
        render json: response, status: 422
      end
    end
  end

  #-----------------------------------------------------------------------------
  # POST create /geolocations
  #-----------------------------------------------------------------------------
  def create
    geolocation = ::Geolocations::Create.new
    geolocation.call(permitted_params) do |m|
      m.success do |response|
        render json: response, status: 201
      end

      m.failure do |response|
        render json: response, status: 422
      end
    end
  end

  #-----------------------------------------------------------------------------
  # DELETE destroy /geolocations/:id
  #-----------------------------------------------------------------------------
  def destroy
    geolocation = set_geolocation("id", params[:id])
    if geolocation.destroy
      render json: { message: "Geolocation deleted" }, status: 200
    else
      render json: { message: "There have been problems with deleting record" }, status: 422
    end
  end

  private

  def permitted_params
    params.permit(:url, :ip)
  end

  def set_geolocation(key, value)
    @geolocation = Geolocation.send("find_by_#{key}", value)
  end
end
