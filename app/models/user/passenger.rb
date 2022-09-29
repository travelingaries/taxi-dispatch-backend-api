# frozen_string_literal: true

class User::Passenger < User
  has_many :taxi_requests
end