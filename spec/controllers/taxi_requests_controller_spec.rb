require 'spec_helper'

RSpec.describe TaxiRequestsController, type: :controller do
  describe 'index' do
    context 'with token' do
      before(:each) do
        @new_passenger = create(:passenger)
        @prev_passenger = create(:passenger)
      end

      it 'passenger' do
        payload = { user_id: @new_passenger.id, exp: 1.day.from_now.to_i }
        token =  JWT.encode(payload, Rails.application.secret_key_base)
        @new_passenger.token = token
        @new_passenger.save!

        @request.headers["Authorization"] = "Token #{token}"

        new_taxi_request = create(:taxi_request, passenger_id: @new_passenger.id)
        prev_taxi_request = create(:taxi_request, passenger_id: @prev_passenger.id)

        get :index
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json.is_a?(Array)).to eq(true)
        expect(json.length).to eq(1)
      end

      it 'driver' do
        driver = create(:driver)
        payload = { user_id: driver.id, exp: 1.day.from_now.to_i }
        token =  JWT.encode(payload, Rails.application.secret_key_base)
        driver.token = token
        driver.save!

        @request.headers["Authorization"] = "Token #{token}"

        new_taxi_request = create(:taxi_request, passenger_id: @new_passenger.id)
        prev_taxi_request = create(:taxi_request, passenger_id: @prev_passenger.id)

        get :index
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json.is_a?(Array)).to eq(true)
        expect(json.length >= 2).to eq(true)
      end
    end

    context 'without valid token' do
      it 'request without valid token' do
        get :index
        expect(response).to have_http_status(401)
      end
    end
  end
end
