# frozen_string_literal: true

require 'jwe'

module CurrentOauth
  extend ActiveSupport::Concern

  def jwe_payload
    payload = jwe
    return nil unless payload
    if (payload['exp'] - Time.now.to_i) < 0
      raise Error
      return nil
    end
    payload
  end

  private

  def jwe
    return @raw_jwe if defined?(@raw_jwe)
    token = token_from_header
    return nil unless token

    jwe_key = "secret_key"
    key = Base64.decode64(jwe_key)
    @raw_jwe = JSON.parse(JWE.decrypt(token, key))
  end

  def token_from_header
    authorization = request.headers['Authorization']
    token = authorization && authorization.match(/Token (?<jwt>.*)/i)
    logger.debug("token: #{token}")
    !token.nil? && token[:jwt]
  end
end