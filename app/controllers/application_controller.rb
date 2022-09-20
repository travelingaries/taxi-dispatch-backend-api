class ApplicationController < ActionController::Base
  include CurrentUser

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format =~ %r{application/json} }

  private

  def authenticate_request
    render json: { message: "로그인이 필요합니다" }, status: ErrorLibrary::Unauthorized.http_status unless current_user.present?
  end
end
