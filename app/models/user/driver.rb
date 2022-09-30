# frozen_string_literal: true

class User
  class Driver < User
    has_many :taxi_requests
  end
end
