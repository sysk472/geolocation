module Geolocations
  class Creator < ApplicationService
    include Dry::Transaction

    step :validate
    step :create
    step :create_geolocation

    private

    attr_accessor :url

    def validate(params)
      result = ::GeolocationContract.new.call(params.to_h)

      return Failure(error: pretty_errors(result.errors.to_h)) unless result.success?

      Success(result[:ip] || prepare_uri(result[:url]))
    end

    def create(params)
      response = ExternalApiCaller.new.call(params)

      response.success? ? Success(response.success) : Failure(response.failure)
    end

    def create_geolocation(body)
      geolocation = Geolocation.create!(
        ip: JSON.parse(body)["ip"],
        url: url,
        data: body
      )

      geolocation.persisted? ? Success(geolocation) : Failure("Something went wrong")
    end
  end
end