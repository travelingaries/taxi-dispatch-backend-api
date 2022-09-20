class TaxiRequestsController < ApplicationController
  before_action :authenticate_request

  def index
    case current_user
    when User::Driver
    when User::Passenger

    end
  end
end