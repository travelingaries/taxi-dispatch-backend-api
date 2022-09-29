# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include CurrentUser

  protect_from_forgery unless: -> { request.format.json? }

  after_action :reset_current_user

  helper_method :current_user

  rescue_from Exception do |e|
    error(e)
  end

  # 400
  rescue_from Exceptions::BadRequest, ActiveRecord::RecordInvalid, ActionController::ParameterMissing, ArgumentError do |e|
    exception_handler e, :bad_request
  end

  # 401
  rescue_from Exceptions::Unauthorized do |e|
    exception_handler e, :unauthorized
  end

  # 403
  rescue_from Exceptions::Forbidden do |e|
    exception_handler e, :forbidden
  end

  # 404
  rescue_from Exceptions::NotFound, ActiveRecord::RecordNotFound do |e|
    exception_handler e, :not_found
  end

  # 409
  rescue_from Exceptions::Conflict, ActiveRecord::RecordNotDestroyed do |e|
    exception_handler e, :conflict
  end

  private

  def authenticate_request
    render json: { message: '로그인이 필요합니다' }, status: Exceptions::Unauthorized.http_status if current_user.blank?
  end

  def exception_handler(e, status, error_code = nil)
    response = {
      data: {},
      meta: {}
    }
    response[:message] = e.message if e.message
    response[:meta][:error_code] = error_code if error_code

    render json: response, status: status
  end

  def error(e)
    Rails.logger.error(e)
    meta = { message: '현재 요청사항을 처리할 수 없습니다. 잠시 후 다시 시도해주세요' }

    render json: { data: {}, meta: meta }, status: :internal_server_error
  end
end
