# frozen_string_literal: true

module Exceptions
  class BaseError < StandardError
    attr_reader :data

    def initialize(message = '', data = {})
      @data = data
      super message
    end

    def self.http_status
      Rack::Utils::SYMBOL_TO_STATUS_CODE[:internal_server_error]
    end

    def self.symbol
      self.name.underscore.to_sym
    end
  end

  class BadRequest < BaseError
    def self.http_status
      Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request]
    end
  end

  class Unauthorized < BaseError
    def self.http_status
      Rack::Utils::SYMBOL_TO_STATUS_CODE[:unauthorized]
    end
  end

  class Forbidden < BaseError
    def self.http_status
      Rack::Utils::SYMBOL_TO_STATUS_CODE[:forbidden]
    end
  end

  class NotFound < BaseError
    def self.http_status
      Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_found]
    end
  end

  class Conflict < BaseError
    def self.http_status
      Rack::Utils::SYMBOL_TO_STATUS_CODE[:conflict]
    end
  end
end
