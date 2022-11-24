module Geolocations
  class Presenter < ApplicationService
    include Dry::Transaction

    step :validate
    step :show

    private

    attr_accessor :url

    def validate(params)
      result = ::GeolocationContract.new.call(params.to_h)

      return Failure(error: pretty_errors(result.errors.to_h)) unless result.success?

      Success(
        result[:ip] ? { ip: result[:ip] } : { url: prepare_uri(result[:url]) }
      )
    end

    def show(params)
      begin
        geolocation = Geolocation.find_by!(params)
      rescue ActiveRecord::RecordNotFound
        response = ExternalApiCaller.call(params.values.first)

        return Failure(error: response.failure) unless response.success?

        geolocation = JSON.parse(response.success)
      end

      geolocation ? Success(geolocation) : Failure(error: 'Failed to get geolocation')
    end
  end
end