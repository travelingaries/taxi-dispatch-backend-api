require 'spec_helper'

RSpec.describe TaxiRequestsController, type: :controller do
  before(:each) do
    @address = Faker::Address.full_address[0...100]
    @exp = 1.day.from_now.to_i
    @secret_key = Rails.application.secret_key_base
  end

  context 'with passenger token' do
    before(:each) do
      @passenger = create(:passenger)
      payload = { user_id: @passenger.id, exp: @exp }
      token = JWT.encode(payload, @secret_key)
      @passenger.token = token
      @passenger.save!

      @request.headers["Authorization"] = "Token #{token}"
    end

    describe 'index' do
      it 'success' do
        prev_passenger = create(:passenger)

        new_taxi_request = create(:taxi_request, passenger_id: @passenger.id)
        prev_taxi_request = create(:taxi_request, passenger_id: prev_passenger.id)

        get :index
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json.is_a?(Array)).to eq(true)
        expect(json.length).to eq(1)
      end
    end

    describe 'create' do
      it 'success' do
        post :create, params: { address: @address }
        expect(response).to have_http_status(200)
      end

      it 'address too long' do
        post :create, params: { address: 'a' * 101 }
        expect(response).to have_http_status(400)
      end

      it 'duplicated' do
        create(:taxi_request, passenger_id: @passenger.id)
        post :create, params: { address: @address }
        expect(response).to have_http_status(409)
      end
    end

    describe 'accept_request' do
      before(:each) do
        @taxi_request = create(:taxi_request, passenger_id: @passenger.id)
      end

      it 'forbidden' do
        post :accept_request, params: { taxi_request_id: @taxi_request.id }
        expect(response).to have_http_status(403)
      end
    end
  end

  context 'with driver token' do
    fixtures :taxi_requests

    before(:each) do
      @driver = create(:driver)
      payload = { user_id: @driver.id, exp: @exp }
      token = JWT.encode(payload, @secret_key)
      @driver.token = token
      @driver.save!

      @request.headers["Authorization"] = "Token #{token}"
    end

    describe 'index' do
      it 'success' do
        get :index
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json.is_a?(Array)).to eq(true)
        expect(json.length >= 4).to eq(true)
      end
    end

    describe 'create' do
      it 'forbidden' do
        post :create, params: { address: @address }
        expect(response).to have_http_status(403)
      end
    end

    describe 'accept_request' do
      before(:each) do
        passenger = create(:passenger)
        @taxi_request = create(:taxi_request, passenger_id: passenger.id)
      end

      it 'success' do
        post :accept_request, params: { taxi_request_id: @taxi_request.id }
        expect(response).to have_http_status(200)
      end

      it 'not found' do
        post :accept_request, params: { taxi_request_id: 0 }
        expect(response).to have_http_status(404)
      end

      it 'already accepted' do
        another_driver = create(:driver)
        @taxi_request.driver = another_driver
        @taxi_request.save!

        post :accept_request, params: { taxi_request_id: @taxi_request.id }
        expect(response).to have_http_status(409)
      end
    end
  end

  context 'without valid token' do
    describe 'index' do
      it 'without token' do
        get :index
        expect(response).to have_http_status(401)
      end

      it 'with nonexistent token' do
        @request.headers["Authorization"] = "Token 1234"

        get :index
        expect(response).to have_http_status(401)
      end
    end

    describe 'create' do
      it 'without token' do
        post :create, params: { address: @address }
        expect(response).to have_http_status(401)
      end
    end

    describe 'accept_request' do
      it 'without token' do
        taxi_request = create(:taxi_request)
        post :accept_request, params: { taxi_request_id: taxi_request.id }
        expect(response).to have_http_status(401)
      end
    end
  end
end
