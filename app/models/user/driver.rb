# frozen_string_literal: true

class User::Driver < User
  has_many :taxi_requests
end