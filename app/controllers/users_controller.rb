class UsersController < ApplicationController
  def sign_in
    param! :email, String, required: true
    param! :password, String, required: true

    user = User.find_by_email(params[:email])
    user = log_in_user(user) if user.authenticate(params[:password]).present?
    logger.debug('got here 2')

    render json: { accessToken: user.token }
  rescue
    render json: { message: "아이디와 비밀번호를 확인해주세요" }, status: ErrorLibrary::InvalidCredentials.http_status
  end

  def sign_up
    param! :email, String, required: true
    param! :password, String, required: true
    param! :userType, String, in: %w[passenger driver], required: true

    prev_user = User.find_by_email(params[:email])
    raise ErrorLibrary::Duplicated if prev_user.present?

    userType = case params[:userType]
               when "driver"
                 User::Driver
               when "passenger"
                 User::Passenger
               end
    unless userType.blank?
      user = userType.create!(
        email: params[:email],
        password: params[:password],
        status: 1
      )
      user.save!
    end

    render json: {
      email: user.email,
      id: user.id,
      userType: userType,
      createdAt: user.created_at,
      updatedAt: user.updated_at
    }
  rescue RailsParam::InvalidParameterError
    message = if params[:email].blank? || !(params[:email] =~ /\A\S+@.+\.\S+\z/)
                "올바른 이메일을 입력해주세요"
              elsif params[:password].blank?
                "올바른 비밀번호를 입력해주세요"
              elsif params[:userType].blank? || !params[:userType].in?(%w[passenger driver])
                "올바른 유저 타입을 입력해주세요"
              end
    render json: { message: message }, status: ErrorLibrary::InvalidParameters.http_status
  rescue ErrorLibrary::Duplicated
    render json: { message: "이미 가입된 이메일입니다" }, status: ErrorLibrary::Duplicated.http_status
  end
end
