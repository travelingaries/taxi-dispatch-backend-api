# frozen_string_literal: true

class CurrentUserProvider
  include CurrentOauth

  CURRENT_USER_KEY ||= '_CURRENT_USER_KEY'

  class << self
    def new_instance(request, response: nil, cookies: nil)
      ins = new(request.env, response)
      ins.request = request
      ins.cookies = cookies
    end
  end

  def initialize(env, response)
    @env = env
    @response = response
  end

  def env_request; @env_request ||= Rack::Request.new(@env) end
  def request; @request ||= env_request end

  def current_user
    return @env[CURRENT_USER_KEY] if @env.key?(CURRENT_USER_KEY)

    current_user = nil
    token_from_header = jwe_payload
    auth_token = token_from_header['auth_token'] if token_from_header

    if auth_token && auth_token.length == 60
      current_user = User.where(token: auth_token).take
    end

    @env[CURRENT_USER_KEY] = current_user
  end

  def log_in_user(user)
    unless user.token && user.token.length == 60
      user.token = SecureRandom.hex(30)
      user.save!
    end
    @env[CURRENT_USER_KEY] = user
  end
end