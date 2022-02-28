require 'exceptions'
class ApplicationService
  include Dry::Transaction

  def self.call(*args, &block)
    new.call(*args, &block)
  end

  def pretty_errors(errors)
    pretty_errors = []
    errors.each do |key, value|
      pretty_errors << "#{key.capitalize} #{value.join(" ")}"
    end
    pretty_errors
  end

  def prepare_uri(url)
    return if url.nil?

    @url = URI.parse(url).host.sub(/^www./,'')
  end
end