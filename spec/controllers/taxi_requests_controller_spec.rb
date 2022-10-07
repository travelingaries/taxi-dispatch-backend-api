# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TaxiRequestsController, type: :controller do
  let(:address) { Faker::Address.full_address[0...100] }
  let(:exp) { 1.day.from_now.to_i }
  let(:secret_key) { Rails.application.secret_key_base }

  subject { JSON.parse(response.body) }

  context '유효한 토큰이 있는 승객인 경우' do
    let!(:passenger) { create(:passenger) }
    let(:payload) { { user_id: passenger.id, exp: exp } }
    let(:token) { JWT.encode(payload, secret_key) }

    before do
      passenger.update!(token: token)

      @request.headers['Authorization'] = "Token #{token}"
    end

    describe '#index' do
      def request
        get :index
      end

      context '올바른 요청인 경우' do
        let!(:another_passenger) { create(:passenger) }

        let!(:new_taxi_request) { create(:taxi_request, passenger: passenger) }
        let!(:prev_taxi_request) { create(:taxi_request, passenger: passenger, status: :completed) }
        let!(:another_taxi_request) { create(:taxi_request, passenger: another_passenger) }

        it_behaves_like 'OK 응답 처리', :request

        let(:expected_response) do
          requests = TaxiRequest.order(id: :desc).where(passenger_id: passenger.id)
          ActiveModel::Serializer::CollectionSerializer.new(requests, serializer: TaxiRequestSerializer).as_json
        end

        it '자신의 배차 요청 목록이 응답된다' do
          request

          expect(subject).to eq(expected_response.as_json)
        end
      end
    end

    describe '#create' do
      def request
        post :create, params: params
      end

      let(:params) { { address: address } }

      context '올바른 요청인 경우' do
        it_behaves_like 'Created 응답 처리', :request
      end

      context '올바르지 않은 요청인 경우' do
        context '주소가 없는 경우' do
          it_behaves_like 'Bad Request 응답 처리', :request do
            let(:params) { {} }
            let(:message) { '주소는 100자 이하로 입력해주세요' }
          end
        end

        context '주소가 너무 긴 경우' do
          it_behaves_like 'Bad Request 응답 처리', :request do
            let(:params) { { address: 'a' * 101 } }
            let(:message) { '주소는 100자 이하로 입력해주세요' }
          end
        end

        context '기존 요청이 있는 경우' do
          before { create(:taxi_request, passenger_id: passenger.id) }

          it_behaves_like 'Conflict 응답 처리', :request do
            let(:message) { '아직 대기중인 배차 요청이 있습니다' }
          end
        end
      end
    end

    describe '#accept_request' do
      def request
        post :accept_request, params: { taxi_request_id: taxi_request.id }
      end

      let!(:taxi_request) { create(:taxi_request, passenger: passenger) }

      context '승객이라 요청을 못 하는 경우' do
        it_behaves_like 'Forbidden 응답 처리', :request do
          let(:message) { '기사만 배차 요청을 수락할 수 있습니다' }
        end
      end
    end
  end

  context '유효한 토큰이 있는 기사인 경우' do
    let!(:driver) { create(:driver) }
    let!(:taxi_requests) { create_list(:taxi_request, 4) }
    let(:payload) { { user_id: driver.id, exp: exp } }
    let(:token) { JWT.encode(payload, secret_key) }

    before do
      driver.update!(token: token)

      @request.headers['Authorization'] = "Token #{token}"
    end

    describe '#index' do
      def request
        get :index
      end

      context '올바른 요청인 경우' do
        it_behaves_like 'OK 응답 처리', :request

        it '응답이 길이 4 이상의 배열이다' do
          request
          expect(subject.is_a?(Array)).to eq(true)
          expect(subject.length >= 4).to eq(true)
        end
      end
    end

    describe '#create' do
      def request
        post :create, params: { address: address }
      end

      context '기사라 요청을 못 하는 경우' do
        it_behaves_like 'Forbidden 응답 처리', :request do
          let(:message) { '승객만 배차 요청할 수 있습니다' }
        end
      end
    end

    describe '#accept_request' do
      def request
        post :accept_request, params: params
      end

      let(:params) { { taxi_request_id: taxi_request.id } }

      let!(:passenger) { create(:passenger) }
      let!(:taxi_request) { create(:taxi_request, passenger: passenger) }

      context '올바른 요청인 경우' do
        it_behaves_like 'OK 응답 처리', :request

        it '응답의 배차 요청 상태가 수락됨 상태다' do
          request
          expect(subject['status']).to eq('accepted')
        end
      end

      context '올바르지 않은 요청인 경우' do
        context '존재하지 않는 요청인 경우' do
          before { params[:taxi_request_id] = 0 }

          it_behaves_like 'Not Found 응답 처리', :request do
            let(:message) { '존재하지 않는 배차 요청입니다' }
          end
        end

        context '이미 수락된 배차 요청인 경우' do
          let!(:another_driver) { create(:driver) }

          before { taxi_request.update!(driver: another_driver) }

          it_behaves_like 'Conflict 응답 처리', :request do
            let(:message) { '수락할 수 없는 배차 요청입니다. 다른 배차 요청을 선택하세요' }
          end
        end
      end
    end
  end

  context '유효한 토큰이 없는 경우' do
    describe '#index' do
      def request
        get :index
      end

      context '토큰이 없는 경우' do
        it_behaves_like 'Unauthorized 응답 처리', :request
      end

      context '발급된 적 없는 토큰인 경우' do
        before do
          @request.headers['Authorization'] = 'Token 1234'
        end

        it_behaves_like 'Unauthorized 응답 처리', :request
      end
    end

    describe '#create' do
      def request
        post :create, params: { address: address }
      end

      context '토큰이 없는 경우' do
        it_behaves_like 'Unauthorized 응답 처리', :request
      end
    end

    describe '#accept_request' do
      def request
        post :accept_request, params: { taxi_request_id: taxi_request.id }
      end

      let!(:passenger) { create(:passenger) }
      let!(:taxi_request) { create(:taxi_request, passenger: passenger) }

      context '토큰이 없는 경우' do
        it_behaves_like 'Unauthorized 응답 처리', :request
      end
    end
  end
end
