# frozen_string_literal: true

class UsersController < ApplicationController
  VALID_USER_TYPES = %w(driver passenger).freeze

  def sign_in
    user_params = sign_in_params

    user = User.find_by(email: user_params[:email])
    raise Exceptions::BadRequest, '아이디와 비밀번호를 확인해주세요' unless user&.authenticate(user_params[:password])

    log_in_user(user)

    json_success({ accessToken: user.token })
  rescue ActionController::ParameterMissing
    raise Exceptions::BadRequest, '아이디와 비밀번호를 확인해주세요'
  end

  def sign_up
    user = CreateUserService.new(sign_up_params).run!

    json_create_success(UserSerializer.new(user).as_json)
  rescue ActiveRecord::RecordInvalid, ActionController::ParameterMissing, Exceptions::BadRequest
    raise_sign_up_errors(params[:email], params[:password], params[:userType])
  end

  private

  def sign_in_params
    params.require(%i(email password))
    params.permit(%i(email password))
  end

  def sign_up_params
    params.require(%i(email password userType))
    params.permit(%i(email password userType))
  end

  def raise_sign_up_errors(email, password, user_type)
    raise Exceptions::BadRequest, '올바른 이메일을 입력해주세요' if email&.match(URI::MailTo::EMAIL_REGEXP).blank?
    raise Exceptions::BadRequest, '올바른 비밀번호를 입력해주세요' if password.blank?
    raise Exceptions::BadRequest, '올바른 사용자 타입을 입력해주세요' unless user_type.in?(%w(passenger driver))
    raise Exceptions::Conflict, '이미 가입된 이메일입니다' if User.exists?(email: params[:email])
  end
end
