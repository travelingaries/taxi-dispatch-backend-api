# frozen_string_literal: true

class TaxiRequestSerializer < BaseSerializer
  attributes :id,
             :address,
             :driverId,
             :passengerId,
             :status,
             :acceptedAt,
             :createdAt,
             :updatedAt

  def id
    object.id
  end

  def address
    object.address
  end

  def driverId
    object.driver_id
  end

  def passengerId
    object.passenger_id
  end

  def status
    object.status
  end

  def acceptedAt
    object.accepted_at
  end

  def createdAt
    object.created_at
  end

  def updatedAt
    object.updated_at
  end
end