# frozen_string_literal: true

class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password

  before_save :downcase_email

  validates :email, length: { maximum: 100 }, format: { with: URI::MailTo::EMAIL_REGEXP }

  USER_TYPES_TO_CLASSES = {
    'driver' => User::Driver,
    'passenger' => User::Passenger
  }.freeze

  class << self
    def type_to_class(user_type)
      USER_TYPES_TO_CLASSES[user_type]
    end
  end

  def downcase_email
    email.downcase!
  end

  def driver?
    is_a?(User::Driver)
  end

  def passenger?
    is_a?(User::Passenger)
  end
end

require 'user/driver'
require 'user/passenger'
