# frozen_string_literal: true

module UserTypeResolver
  extend ActiveSupport::Concern

  include CurrentUser

  def allow_passengers_only(message)
    validate_user_type(message, User::Passenger)
  end

  def allow_drivers_only(message)
    validate_user_type(message, User::Driver)
  end

  private

  def validate_user_type(message, user_type)
    raise Exceptions::Forbidden, message unless current_user.is_a?(user_type)
  end
end