# frozen_string_literal: true

class TaxiRequest < ApplicationRecord
  belongs_to :passenger, class_name: "User::Passenger", foreign_key: :passenger_id
  belongs_to :driver, optional: true, class_name: "User::Driver", foreign_key: :driver_id

  enum status: { waiting: 'waiting', accepted: 'accepted', canceled: 'canceled', completed: 'completed' }

  validates :address, length: { maximum: 100 }
end
