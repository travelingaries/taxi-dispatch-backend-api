# frozen_string_literal: true

class TaxiRequestsController < ApplicationController
  before_action :authenticate_request

  def index
    query = TaxiRequest.order(created_at: :desc)
    query = query.where(passenger_id: current_user.id) if current_user.is_a?(User::Passenger)

    taxi_requests = []
    query.find_each(batch_size: 50) do |request|
      taxi_requests << {
        id: request.id,
        address: request.address,
        driverId: request.driver_id,
        passengerId: request.passenger_id,
        status: request.status_lang,
        acceptedAt: request.accepted_at,
        createdAt: request.created_at,
        updatedAt: request.updated_at
      }
    end

    render json: taxi_requests
  end

  def create
    raise ErrorLibrary::Forbidden if current_user.is_a?(User::Driver)

    param! :address, String, required: true
    raise ErrorLibrary::InvalidParameters if params[:address].length > 100

    prev_request = TaxiRequest.where(passenger_id: current_user.id, status: 1).order(created_at: :desc).first
    raise ErrorLibrary::Duplicated if prev_request.present?

    request = TaxiRequest.create!(
      passenger_id: current_user.id,
      address: params[:address],
      status: 1
    )

    render json: {
      id: request.id,
      address: request.address,
      driverId: request.driver_id,
      passengerId: request.passenger_id,
      status: request.status_lang,
      createdAt: request.created_at,
      updatedAt: request.updated_at
    }
  rescue RailsParam::InvalidParameterError, ErrorLibrary::InvalidParameters
    render json: { message: '주소는 100자 이하로 입력해주세요' }, status: ErrorLibrary::InvalidParameters.http_status
  rescue ErrorLibrary::Forbidden
    render json: { message: '승객만 배차 요청할 수 있습니다' }, status: ErrorLibrary::Forbidden.http_status
  rescue ErrorLibrary::Duplicated
    render json: { message: '아직 대기중인 배차 요청이 있습니다' }, status: ErrorLibrary::Forbidden.http_status
  end

  def accept_request
    raise ErrorLibrary::Forbidden if current_user.is_a?(User::Passenger)

    param! :taxi_request_id, Integer, required: true

    request = TaxiRequest.find_by(id: params[:taxi_request_id])
    raise ErrorLibrary::NotFound if request.blank?
    raise ErrorLibrary::Duplicated if request.driver_id.present?

    request.update!(driver_id: current_user.id, accepted_at: Time.current)

    render json: {
      id: request.id,
      address: request.address,
      driverId: request.driver_id,
      passengerId: request.passenger_id,
      status: request.status_lang,
      createdAt: request.created_at,
      updatedAt: request.updated_at
    }
  rescue ErrorLibrary::Forbidden
    render json: { message: '기사만 배차 요청을 수락할 수 있습니다' }, status: ErrorLibrary::Forbidden.http_status
  rescue ErrorLibrary::NotFound
    render json: { message: '존재하지 않는 배차 요청입니다' }, status: ErrorLibrary::NotFound.http_status
  rescue ErrorLibrary::Duplicated
    render json: { message: '수락할 수 없는 배차 요청입니다. 다른 배차 요청을 선택하세요' }, status: ErrorLibrary::Duplicated.http_status
  end
end
