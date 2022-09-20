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

    userType = params[:userType]
    userType[0] = userType[0].capitalize

    logger.debug("password: #{BCrypt::Password}")

    user = User.create!(
      type: "User::#{userType}",
      email: params[:email].downcase!,
      password: params[:password],
      status: 1
    )
    user.save!

    render json: {
      email: user.email,
      id: user.id,
      userType: userType,
      createdAt: user.created_at,
      updatedAt: user.updated_at
    }
  end
end
