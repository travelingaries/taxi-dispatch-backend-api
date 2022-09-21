require 'spec_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'authenticate_request' do
    controller(ApplicationController) do
      before_action :authenticate_request

      def index
        render json: {}
      end
    end

    context 'authenticate_request' do
      it 'token not set' do
        set_request
        get :index
        expect(response).to have_http_status(401)
      end

      it 'token invalid' do
        user = User.new
        user.token = "1234"

        set_request(user: user)
        get :index
        expect(response).to have_http_status(401)
      end

      it 'token expired' do
        current_user_provider = CurrentUserProvider.new_instance(request)

        user = create(:user)
        user = current_user_provider.log_in_user(user)
        current_user_provider.reset_current_user

        set_request(user: user)
        Timecop.travel(Time.now + 1.year) do
          get :index
        end
        expect(response).to have_http_status(401)
      end

      it 'token valid' do
        user = create(:user)
        user = CurrentUserProvider.new_instance(request).log_in_user(user)

        set_request(user: user)
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end
end
