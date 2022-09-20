require 'rspec'

RSpec.describe TaxiRequestsController, type: :controller do
  context 'index' do
    fixtures :users
    it 'success' do
      @request.headers["Authorization"] = "Token eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NjM3NDg2OTd9.-Pq8X4YTM8MDM4dXMmiogbrb0UvRXegjOVs7uHIEVpc"
      get :index
    end
  end
end
