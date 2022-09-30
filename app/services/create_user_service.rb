# frozen_string_literal: true

class CreateUserService
  def initialize(params)
    @params = params.dup
  end

  def run!
    user_type = case @params[:userType]
                when 'driver'
                  User::Driver
                when 'passenger'
                  User::Passenger
                else
                  return
                end
    user_type.create!(
      email: @params[:email],
      password: @params[:password],
      status: @params[:status] || 'normal'
    )
  end
end
