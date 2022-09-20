class UsersController < ApplicationController
  def login
    logger.debug('hi')
    render json: {
      contents: 'hi'
    }.as_json
  end

  def sign_up
    param! :email, String, required: true
    param! :password, String, required: true
    param! :userType, String, in: %w[passenger driver], required: true

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
    render json: { message: message }, status: :bad_request
  end
end
