# frozen_string_literal: true

class UsersController < ApplicationController
  def sign_in
    param! :email, String, required: true
    param! :password, String, required: true

    user = User.find_by(email: params[:email])

    raise Exceptions::BadRequest, '아이디와 비밀번호를 확인해주세요' unless user&.authenticate(params[:password])

    log_in_user(user)
    render json: { accessToken: user.token }
  rescue RailsParam::InvalidParameterError
    render json: { message: '아이디와 비밀번호를 확인해주세요' }, status: Exceptions::BadRequest.http_status
  end

  def sign_up
    user_params = sign_up_params

    prev_user = User.find_by(email: user_params[:email])
    raise Exceptions::Conflict, '이미 가입된 이메일입니다' if prev_user.present?

    user = CreateUserService.new(user_params).run!

    render json: user,
           serializer: UserSerializer
  rescue ActionController::ParameterMissing
    message = if !valid_email?(params[:email])
                '올바른 이메일을 입력해주세요'
              elsif params[:password].blank?
                '올바른 비밀번호를 입력해주세요'
              elsif !valid_user_type?(params[:userType])
                '올바른 유저 타입을 입력해주세요'
              end
    raise Exceptions::BadRequest, message
  end

  private

  def sign_in_params
    params.require(%i(email password))
    params.permit(%i(email password))
  end

  def sign_up_params
    params.require(%i(email password userType))

    raise Exceptions::BadRequest, '올바른 이메일을 입력해주세요' unless valid_email?(params[:email])
    raise Exceptions::BadRequest, '올바른 유저 타입을 입력해주세요' unless valid_user_type?(params[:userType])

    params.permit(%i(email password userType))
  end

  def valid_email?(email)
    email&.match(/\A\S+@.+\.\S+\z/).present?
  end

  def valid_user_type?(user_type)
    user_type.in?(%w(passenger driver))
  end
end
