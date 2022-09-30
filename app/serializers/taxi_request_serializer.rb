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

  delegate :id, to: :object
  delegate :passenger_id, to: :object
  delegate :driver_id, to: :object
  delegate :address, to: :object
  delegate :status, to: :object
  delegate :accepted_at, to: :object
  delegate :created_at, to: :object
  delegate :updated_at, to: :object

  alias passengerId passenger_id
  alias driverId driver_id
  alias acceptedAt accepted_at
  alias createdAt created_at
  alias updatedAt updated_at
end
