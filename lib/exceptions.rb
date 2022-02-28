module Exceptions
  class ::AddressIpInvalid < StandardError
    def message
      'IP Address is invalid'
    end
  end

  class ::AccessKey < StandardError
    def message
      'Missing access key or key invalid'
    end
  end

  class ::InvalidApiFunction < StandardError
    def message
      'Invalid api function'
    end
  end

  class ::LimitExceeded < StandardError
    def message
      'Limit exceeded'
    end
  end

  class ::AccessRestricted < StandardError
    def message
      'Access restricted'
    end
  end

  class ::InvalidFields < StandardError
    def message
      'Invalid fields'
    end
  end
  class ::TooManyIps < StandardError
    def message
      'Too many ips'
    end
  end

  class ::NotFound < StandardError
    def message
      'Not found'
    end
  end

  class ::ConnectionError < StandardError
    def message
      'There was an error with connecting external API'
    end
  end

  EXTERNAL_API =  [
    AddressIpInvalid,
    AccessKey,
    InvalidApiFunction,
    LimitExceeded,
    AccessRestricted,
    InvalidFields,
    TooManyIps,
    NotFound
  ]
end
