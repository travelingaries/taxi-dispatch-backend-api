# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include CurrentUser
  include JsonResolver

  protect_from_forgery unless: -> { request.format.json? }

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
    raise Exceptions::Unauthorized, '로그인이 필요합니다' if current_user.blank?
  end

  def exception_handler(e, status)
    render json:{ message: e.message }, status: status
  end

  def error(e)
    Rails.logger.error(e)

    render json: { message: '현재 요청사항을 처리할 수 없습니다. 잠시 후 다시 시도해주세요' }, status: :internal_server_error
  end
end
