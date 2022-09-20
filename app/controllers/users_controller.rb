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
  end
end
