# frozen_string_literal: true

class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password

  if self.attribute(:type) == "User::Driver"
    has_many :taxi_requests, -> { where(driver_id: self.attribute(:id)) }
  else
    has_many :taxi_requests, -> { where(passenger_id: self.attribute(:id)) }
  end

  before_save :downcase_email

  def downcase_email
    email.downcase!
  end
end

require 'user/driver'
require 'user/passenger'
