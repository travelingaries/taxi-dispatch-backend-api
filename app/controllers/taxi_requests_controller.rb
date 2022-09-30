# frozen_string_literal: true

class TaxiRequestsController < ApplicationController
  before_action :authenticate_request
  before_action only: :create do
    allow_passengers_only('승객만 배차 요청할 수 있습니다')
  end
  before_action only: :accept_request do
    allow_drivers_only('기사만 배차 요청을 수락할 수 있습니다')
  end

  include UserTypeResolver

  def index
    requests = TaxiRequest.order(id: :desc)
    requests = requests.where(passenger_id: current_user.id) if current_user.is_a?(User::Passenger)

    render json: ActiveModel::Serializer::CollectionSerializer.new(
      requests,
      serializer: TaxiRequestSerializer
    )
  end

  def create
    prev_request = TaxiRequest.where(passenger_id: current_user.id).order(created_at: :desc).first
    raise Exceptions::Conflict, '아직 대기중인 배차 요청이 있습니다' if prev_request.present?

    request = TaxiRequest.create!(create_params)

    render json: request,
           serializer: TaxiRequestSerializer
  rescue ActiveRecord::RecordInvalid
    raise Exceptions::BadRequest, '주소는 100자 이하로 입력해주세요'
  end

  def accept_request
    request = TaxiRequest.find_by(id: accept_request_params[:taxi_request_id])
    raise Exceptions::NotFound, '존재하지 않는 배차 요청입니다' if request.blank?
    raise Exceptions::Conflict, '수락할 수 없는 배차 요청입니다. 다른 배차 요청을 선택하세요' if request.driver_id.present?

    request.update!(driver_id: current_user.id, accepted_at: Time.current)

    render json: request,
           serializer: TaxiRequestSerializer
  end

  private

  def create_params
    params.require(:address)
    params.merge(passenger_id: current_user.id).permit(:passenger_id, :address)
  end

  def accept_request_params
    params.require(:taxi_request_id)
    params.permit(:taxi_request_id)
  end
end
