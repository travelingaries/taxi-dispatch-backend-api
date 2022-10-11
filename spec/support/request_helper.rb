# frozen_string_literal: true

module Requests
  def add_token_to_request(user: nil)
    request.headers['Authorization'] = "Token #{user.token}" if user.present?
  end
end
