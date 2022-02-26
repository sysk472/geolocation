module Geolocations
  class Create < ApplicationService
    include Dry::Transaction
    attr_accessor :url
    step :validate
    step :create
    step :create_geolocation

    private

    def validate(input)
      result = ::GeolocationContract.new.call(input.to_h)

      Failure(error: 'Incorrect parameter') unless result.success?

      Success(result[:ip] || prepare_uri(result[:url]))
    end

    def create(input)
      response = ExternalApiCall.new.call(input)

      response.success? ? Success(response.success) : Failure(error: 'Failed')
    end

    def prepare_uri(url)
      return if url.empty?

      @url = URI.parse(url).host.sub(/^www\./, '')
    end

    def create_geolocation(input)
      input = "{\"ip\": \"195.245.224.52\", \"type\": \"ipv4\", \"continent_code\": \"EU\", \"continent_name\": \"Europe\", \"country_code\": \"PL\", \"country_name\": \"Poland\", \"region_code\": \"SL\", \"region_name\": \"Silesia\", \"city\": \"Katowice\", \"zip\": \"40-389\", \"latitude\": 50.25569152832031, \"longitude\": 19.10357093811035, \"location\": {\"geoname_id\": 3096472, \"capital\": \"Warsaw\", \"languages\": [{\"code\": \"pl\", \"name\": \"Polish\", \"native\": \"Polski\"}], \"country_flag\": \"https://assets.ipstack.com/flags/pl.svg\", \"country_flag_emoji\": \"\\ud83c\\uddf5\\ud83c\\uddf1\", \"country_flag_emoji_unicode\": \"U+1F1F5 U+1F1F1\", \"calling_code\": \"48\", \"is_eu\": true}}"

      geolocation = Geolocation.create(
        ip: JSON.parse(input)["ip"],
        url: url,
        data: input
      )

      geolocation.persisted? ? Success(geolocation) : Failure("Something went wrong")
    end
  end
end