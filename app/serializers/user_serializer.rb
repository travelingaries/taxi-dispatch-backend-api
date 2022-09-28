# frozen_string_literal: true

class UserSerializer < BaseSerializer
  attributes :email,
             :id,
             :userType,
             :createdAt,
             :updatedAt

  def email
    object.email
  end

  def id
    object.id
  end

  def userType
    case object
    when User::Driver
      'driver'
    when User::Passenger
      'passenger'
    end
  end

  def createdAt
    object.created_at
  end

  def updatedAt
    object.updated_at
  end
end
