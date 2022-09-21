module Requests
  def set_request(user: nil)
    request.headers['Authorization'] = "Token #{user.token}" if user.present?
  end
end