class GeolocationContract < ApplicationContract
  params do
    optional(:ip).value(format?: Resolv::IPv4::Regex)
    optional(:url).value(format?: /\A#{URI::regexp}\z/)
  end

  rule(:ip, :url) do
    key(:params).failure('wrong number of them') unless values[:ip].nil? ^ values[:url].nil?
  end
end