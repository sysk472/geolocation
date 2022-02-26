module Geolocations
  class Show < ApplicationService
    include Dry::Transaction
    attr_accessor :url
    step :validate
    step :show

    private

    def validate(input)
      result = ::GeolocationContract.new.call(input.to_h)

      Failure(error: 'Incorrect parameter') unless result.success?

      Success({ ip: result[:ip] } || { url: prepare_uri(result[:url]) })
    end

    def show(input)
      byebug
      @geolocation = Geolocation.find_by(input) || ExternalApiCall.new.call(input)


      response = ExternalApiCall.new.call(input)

      response.success? ? Success(response.success) : Failure(error: 'Failed')
    end
  end
end