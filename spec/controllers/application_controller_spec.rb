# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ApplicationController, type: :controller do
  subject { JSON.parse(response.body) }

  describe '#authenticate_request' do
    controller(ApplicationController) do
      before_action :authenticate_request

      def index
        render json: {}
      end
    end

    def request_index
      get :index
    end

    context '발급됐던 토큰이 헤더에 있을 때' do
      let!(:user) { create(:user) }
      let(:current_user_provider) { CurrentUserProvider.new_instance(request) }

      before do
        current_user_provider.log_in_user(user)
        add_token_to_request(user: user)
      end

      it_behaves_like 'OK 응답 처리', :request_index

      context '토큰이 만료되었을 때' do
        before do
          current_user_provider.reset_current_user
          Timecop.travel(1.year.from_now)
        end

        it_behaves_like 'Unauthorized 응답 처리', :request_index
      end
    end

    context '유효하지 않은 토큰이 헤더에 있을 때' do
      let!(:user) { create(:user) }

      before do
        user.token = '1234'
        add_token_to_request(user: user)
      end

      it_behaves_like 'Unauthorized 응답 처리', :request_index
    end

    context '헤더에 토큰이 없을 때' do
      before do
        add_token_to_request
      end

      it_behaves_like 'Unauthorized 응답 처리', :request_index
    end
  end
end
