# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include CurrentUser

  protect_from_forgery unless: -> { request.format.json? }

  after_action :reset_current_user

  helper_method :current_user

  private

  def authenticate_request
    render json: { message: '로그인이 필요합니다' }, status: ErrorLibrary::Unauthorized.http_status if current_user.blank?
  end
end
