# frozen_string_literal: true

class User
  class Passenger < User
    has_many :taxi_requests
  end
end
