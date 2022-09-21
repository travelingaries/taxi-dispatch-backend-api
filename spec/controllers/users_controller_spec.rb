require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  describe 'sign_in' do
    fixtures :users
    it "success" do
      post :sign_in, params: { email: "passenger1@dramancompany.com", password: "eiusmod" }
      expect(response).to have_http_status(200)
    end

    it "incorrect credentials" do
      post :sign_in, params: { email: "drama@dramancompany.com", password: "eiusmod" }
      expect(response).to have_http_status(400)
    end
  end
end