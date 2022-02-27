module Geolocations
  class Show < ApplicationService
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
        geolocation = JSON.parse(
          ExternalApiCall.new.call(params.values.first).success
        )
      end
      # pytanie jak mam rozpatrywac jak przyjdzie 106 np
      geolocation ? Success(geolocation) : Failure(error: 'Failed')
    end
  end
end