# frozen_string_literal: true

class CreateUserService
  def initialize(params)
    @params = params.dup
  end

  def run!
    user_type = User.type_to_class(@params[:userType])
    user_type.create!(
      email: @params[:email],
      password: @params[:password],
      status: @params[:status].presence || 'normal'
    )
  end
end
