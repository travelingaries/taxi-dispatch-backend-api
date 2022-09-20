# frozen_string_literal: true

module ErrorLibrary
  class BaseError < StandardError
    def self.http_status; Rack::Utils::SYMBOL_TO_STATUS_CODE[:internal_server_error] end
    def self.symbol; self.name.underscore.to_sym end
  end

  class InvalidParameters < BaseError
    def self.http_status; Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] end
  end

  class InvalidCredentials < BaseError
    def self.http_status; Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request] end
  end

  class Unauthorized < BaseError
    def self.http_status; Rack::Utils::SYMBOL_TO_STATUS_CODE[:unauthorized] end
  end

  class Duplicated < BaseError
    def self.http_status; Rack::Utils::SYMBOL_TO_STATUS_CODE[:conflict] end
  end
end