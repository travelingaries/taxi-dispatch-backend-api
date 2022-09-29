# frozen_string_literal: true

class TaxiRequestsController < ApplicationController
  before_action :authenticate_request

  def index
    requests = TaxiRequest.order(created_at: :desc)
    requests = requests.where(passenger_id: current_user.id) if current_user.is_a?(User::Passenger)

    render json: ActiveModel::Serializer::CollectionSerializer.new(
      requests,
      serializer: TaxiRequestSerializer
    )
  end

  def create
    raise ErrorLibrary::Forbidden if current_user.is_a?(User::Driver)

    prev_request = TaxiRequest.where(passenger_id: current_user.id, status: 1).order(created_at: :desc).first
    raise ErrorLibrary::Duplicated if prev_request.present?

    request = TaxiRequest.create!(create_params)

    render json: request,
           serializer: TaxiRequestSerializer
  rescue RailsParam::InvalidParameterError, ErrorLibrary::InvalidParameters, ActiveRecord::RecordInvalid
    render json: { message: '주소는 100자 이하로 입력해주세요' }, status: ErrorLibrary::InvalidParameters.http_status
  rescue ErrorLibrary::Forbidden
    render json: { message: '승객만 배차 요청할 수 있습니다' }, status: ErrorLibrary::Forbidden.http_status
  rescue ErrorLibrary::Duplicated
    render json: { message: '아직 대기중인 배차 요청이 있습니다' }, status: ErrorLibrary::Duplicated.http_status
  end

  def accept_request
    raise ErrorLibrary::Forbidden if current_user.is_a?(User::Passenger)

    param! :taxi_request_id, Integer, required: true

    request = TaxiRequest.find_by(id: params[:taxi_request_id])
    raise ErrorLibrary::NotFound if request.blank?
    raise ErrorLibrary::Duplicated if request.driver_id.present?

    request.update!(driver_id: current_user.id, accepted_at: Time.current)

    render json: request,
           serializer: TaxiRequestSerializer
  rescue ErrorLibrary::Forbidden
    render json: { message: '기사만 배차 요청을 수락할 수 있습니다' }, status: ErrorLibrary::Forbidden.http_status
  rescue ErrorLibrary::NotFound
    render json: { message: '존재하지 않는 배차 요청입니다' }, status: ErrorLibrary::NotFound.http_status
  rescue ErrorLibrary::Duplicated
    render json: { message: '수락할 수 없는 배차 요청입니다. 다른 배차 요청을 선택하세요' }, status: ErrorLibrary::Duplicated.http_status
  end

  private

  def create_params
    params.require(:address)
    params.merge(passenger_id: current_user.id, status: 1).permit(:passenger_id, :address, :status)
  end
end
