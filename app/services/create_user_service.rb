# frozen_string_literal: true

class CreateUserService
  def initialize(params)
    @params = params.dup
  end

  def run!
    user_class = User.type_to_class(@params[:userType])
    raise Exceptions::BadRequest, '올바른 사용자 타입을 입력해주세요' if user_class.nil?

    user_class.create!(
      email: @params[:email],
      password: @params[:password],
      status: @params[:status].presence || 'normal'
    )
  end
end
