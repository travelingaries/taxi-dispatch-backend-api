require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  password = "password"

  describe 'sign_up' do
    context 'with email' do
      email = "test@email.com"
      password = "password"

      it "passenger success" do
        user_type = "passenger"
        post :sign_up, params: { email: email, password: password, userType: user_type }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['id']).to_not be_nil
      end

      it "driver success" do
        user_type = "driver"
        post :sign_up, params: { email: email, password: password, userType: user_type }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['id']).to_not be_nil
      end

      it "user duplicated" do
        prev_user = create(:user, password_digest: BCrypt::Password.create(password))
        post :sign_up, params: { email: prev_user.email, password: password, userType: "passenger" }
        expect(response).to have_http_status(409)
      end

      it "without email" do
        post :sign_up, params: { password: password, userType: "passenger" }
        expect(response).to have_http_status(400)
      end

      it "without password" do
        post :sign_up, params: { email: email, userType: "passenger" }
        expect(response).to have_http_status(400)
      end

      it "without user type" do
        post :sign_up, params: { email: email, password: password }
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'sign_in' do
    let(:user) { create(:user, password_digest: BCrypt::Password.create(password)) }

    context 'with email' do
      it "success" do
        post :sign_in, params: { email: user.email, password: password }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['accessToken']).to_not be_nil
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