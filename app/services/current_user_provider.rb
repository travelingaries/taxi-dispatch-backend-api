# frozen_string_literal: true

class CurrentUserProvider
  include CurrentOauth

  CURRENT_USER_KEY ||= '_CURRENT_USER_KEY'

  attr_accessor :request, :response

  class << self
    def new_instance(request, response: nil)
      ins = new(request.env, response)
      ins.request = request
      ins
    end
  end

  def initialize(env, response)
    @env = env
    @response = response
  end

  def current_user
    return @env[CURRENT_USER_KEY] if @env.key?(CURRENT_USER_KEY)

    current_user = nil
    current_user = User.where(token: token_from_header).take if token_valid?

    @env[CURRENT_USER_KEY] = current_user
  end

  def log_in_user(user)
    user.update!(token: jwt_encode(user_id: user.id))
    @env[CURRENT_USER_KEY] = user
  end

  def reset_current_user
    @env[CURRENT_USER_KEY] = nil
  end
end
