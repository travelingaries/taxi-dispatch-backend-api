# frozen_string_literal: true

require 'current_user_provider'

module CurrentUser
  extend ActiveSupport::Concern

  delegate :log_in_user, to: :current_user_provider

  delegate :current_user, to: :current_user_provider

  delegate :reset_current_user, to: :current_user_provider

  private

  def current_user_provider
    @current_user_provider ||= CurrentUserProvider.new_instance(request, response: response)
  end
end
