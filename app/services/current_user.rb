# frozen_string_literal: true

require 'current_user_provider'

module CurrentUser
  extend ActiveSupport::Concern

  def log_in_user(user)
    current_user_provider.log_in_user(user)
  end

  def current_user
    current_user_provider.current_user
  end

  def reset_current_user
    current_user_provider.reset_current_user
  end

  private

  def current_user_provider
    @current_user_provider ||= CurrentUserProvider.new_instance(request, response: response)
  end
end
