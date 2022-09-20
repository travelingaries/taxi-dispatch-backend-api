class User < ApplicationRecord
  include ActiveModel::SecurePassword
  validates_uniqueness_of :email
  has_secure_password

  before_save :downcase_email

  def downcase_email
    self.email.downcase!
  end
end

require 'user/driver'
require 'user/passenger'