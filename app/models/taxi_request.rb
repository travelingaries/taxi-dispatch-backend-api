# frozen_string_literal: true

class TaxiRequest < ApplicationRecord
  belongs_to :passenger, class_name: "User::Passenger", foreign_key: :passenger_id
  belongs_to :driver, optional: true, class_name: "User::Driver", foreign_key: :driver_id

  validates :address, length: { maximum: 100 }

  def status_lang
    case status
    when 1
      :waiting
    when 2
      :accepted
    when 3
      :canceled
    when 4
      :completed
    end
  end
end
