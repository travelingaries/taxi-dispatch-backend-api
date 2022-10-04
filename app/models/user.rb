# frozen_string_literal: true

class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password

  before_save :downcase_email

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
