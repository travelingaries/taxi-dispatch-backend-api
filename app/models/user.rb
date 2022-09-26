# frozen_string_literal: true

class User < ApplicationRecord
  include ActiveModel::SecurePassword
  has_secure_password

  before_save :downcase_email

  def downcase_email
    email.downcase!
  end
end

require 'user/driver'
require 'user/passenger'
