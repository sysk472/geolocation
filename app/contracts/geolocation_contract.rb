class GeolocationContract < ApplicationContract
  params do
    optional(:ip).value(format?: Resolv::IPv4::Regex)
    optional(:url).value(format?: /\A#{URI::regexp}\z/)
  end
end