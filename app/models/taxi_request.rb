# frozen_string_literal: true

class TaxiRequest < ApplicationRecord
  belongs_to :passenger, class_name: 'User::Passenger'
  belongs_to :driver, optional: true, class_name: 'User::Driver'

  enum status: { standBy: 'standBy', accepted: 'accepted', canceled: 'canceled', completed: 'completed' }

  validates :address, length: { maximum: 100 }

  def accepted?
    driver.present?
  end

  def accept!(user)
    return unless user.driver?

    update!(driver_id: user.id, status: :accepted, accepted_at: Time.current)
  end
end
