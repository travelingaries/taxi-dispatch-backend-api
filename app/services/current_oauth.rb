# frozen_string_literal: true

require 'jwt'

module CurrentOauth
  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.secret_key_base

  def jwt_encode(payload, exp = 1.day.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  rescue StandardError
    nil
  end

  def token_valid?(token = nil)
    token = token_from_header if token.blank?
    return false if token.blank?

    payload = jwt_decode(token)
    return false if payload.nil?

    (payload['exp'] - Time.now.to_i).positive?
  end

  private

  def token_from_header
    authorization = request.headers['Authorization']
    token = authorization && authorization.match(/Token (?<jwt>.*)/i)
    !token.nil? && token[:jwt]
  end
end
