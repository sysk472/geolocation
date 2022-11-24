class Api::V1::GeolocationsController < ApplicationController
  before_action :set_geolocation, only: %i[show destroy]

  #-----------------------------------------------------------------------------
  # GET show_by_query /geolocations? ip || url
  #-----------------------------------------------------------------------------
  def show_by_query
    ::Geolocations::Presenter.call(query_params) do |final_step|
      final_step.success do |response|
        render json: { geolocation: response }, status: 200
      end

      final_step.failure do |response|
        render json: response, status: 422
      end
    end
  end

  #-----------------------------------------------------------------------------
  # GET show /geolocations/:id
  #-----------------------------------------------------------------------------
  def show
    render json: { geolocation: @geolocation }, status: 200
  end

  #-----------------------------------------------------------------------------
  # POST create /geolocations
  #-----------------------------------------------------------------------------
  def create
    ::Geolocations::Creator.call(permitted_params) do |final_step|
      final_step.success do |response|
        render json: { geolocation: response }, status: 201
      end

      final_step.failure do |response|
        render json: response, status: 422
      end
    end
  end

  #-----------------------------------------------------------------------------
  # DELETE destroy /geolocations/:id
  #-----------------------------------------------------------------------------
  def destroy
    if @geolocation.destroy
      render json: {
        geolocation: "Geolocation deleted"
      }, status: 204
    else
      render json: { error:
        "There have been problems with deleting record"
      }, status: 422
    end
  end

  private

  def permitted_params
    params.require(:geolocation).permit(:url, :ip)
  end

  def query_params
    params.permit(:url, :ip)
  end

  def set_geolocation
    @geolocation = Geolocation.find_by!(id: params[:id])
  end
end
