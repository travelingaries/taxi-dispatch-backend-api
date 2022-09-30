# frozen_string_literal: true

class UserSerializer < BaseSerializer
  attributes :email,
             :id,
             :userType,
             :createdAt,
             :updatedAt

  delegate :email, to: :object
  delegate :id, to: :object
  delegate :created_at, to: :object
  delegate :updated_at, to: :object

  alias createdAt created_at
  alias updatedAt updated_at

  def user_type
    case object
    when User::Driver
      'driver'
    when User::Passenger
      'passenger'
    end
  end

  alias userType user_type
end
