class ExternalApiCall < ApplicationService
  include Dry::Transaction

  attr_accessor :param
  tee :set_params
  step :call_client

  def set_params(param)
    @param = param
  end

  def call_client
    begin
      @response = Faraday.get(external_api_uri(param))
    rescue Faraday::ResourceNotFound => e
      Failure(e)
    rescue Faraday::ServerError => e
      Failure(e)
    rescue => e
      Failure(e)
    end

    Success("@response.body")
  end

  def external_api_uri(param)
    URI::HTTP.build(
      host: Rails.application.credentials[:IP_STACK_URL],
      path: "/#{param}",
      query: {
        access_key: Rails.application.credentials[:IP_STACK_ACCESS_KEY]
      }.to_query
    )
  end
end