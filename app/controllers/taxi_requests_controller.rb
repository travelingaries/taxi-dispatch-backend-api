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
end