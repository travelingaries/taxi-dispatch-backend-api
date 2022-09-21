require 'rspec'

RSpec.describe TaxiRequestsController, type: :controller do
  context 'index' do
    fixtures :users, :taxi_requests
    it 'passenger' do
      @request.headers["Authorization"] = "Token eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NjM3NDg2OTd9.-Pq8X4YTM8MDM4dXMmiogbrb0UvRXegjOVs7uHIEVpc"
      get :index
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.is_a?(Array)).to eq(true)
    end

    it 'driver' do
      @request.headers["Authorization"] = "Token eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE2NjM4MDczMTR9.u4dWV8C-ZrE_nWQAyOl6X7ZCS8pp1746naXBdOp_1BU"
      get :index
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.is_a?(Array)).to eq(true)
    end

    it 'request without valid token' do
      get :index
      expect(response).to have_http_status(401)
    end
  end
end
