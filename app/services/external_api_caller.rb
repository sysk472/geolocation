class ExternalApiCaller < ApplicationService
  include Dry::Transaction

  tee :set_params
  step :call_client

  private

  attr_reader :param

  def set_params(param)
    @param = param
  end

  def call_client
    begin
      response = Net::HTTP.get(external_api_uri(param))

      case JSON.parse(response)["error"]["code"]
      when 101
        raise AccessKey
      when 103
        raise InvalidApiFunction
      when 104
        raise LimitExceeded
      when 105
        raise AccessRestricted
      when 106
        raise AddressIpInvalid
      when 301
        raise InvalidFields
      when 302
        raise TooManyIps
      when 404
        raise NotFound
      when nil
        Success(response)
      end
    rescue *Exceptions::EXTERNAL_API => e
      Failure(e.message)
    rescue ConnectionError => e
      Failure(e.message)
    end
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