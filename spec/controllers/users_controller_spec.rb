require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  password = "password"

  describe 'sign_in' do
    let(:user) { create(:user, password_digest: BCrypt::Password.create(password)) }

    context 'with email' do
      it "success" do
        post :sign_in, params: { email: user.email, password: password }
        expect(response).to have_http_status(200)
      end

      it "incorrect credentials" do
        post :sign_in, params: { email: user.email, password: "hi" }
        expect(response).to have_http_status(400)
      end

      it "no password provided" do
        post :sign_in, params: { email: user.email }
        expect(response).to have_http_status(400)
      end
    end
  end
end