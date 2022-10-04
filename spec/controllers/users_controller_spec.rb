# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  let(:password) { 'password' }

  subject { JSON.parse(response.body) }

  describe '#sign_up' do
    def request
      post :sign_up, params: params
    end

    let(:email) { 'test@email.com' }
    let(:params) { { email: email, password: password, userType: 'passenger' } }

    context '올바른 승객 가입 요청인 경우' do
      it_behaves_like 'OK 응답 처리', :request

      it '응답에 id 정보가 포함된다' do
        request
        expect(subject['id']).to_not be_nil
      end
    end

    context '올바른 기사 가입 요청인 경우' do
      before { params[:userType] = 'driver' }

      it_behaves_like 'OK 응답 처리', :request

      it '응답에 id 정보가 포함된다' do
        request
        expect(subject['id']).to_not be_nil
      end
    end

    context '이미 가입된 이메일인 경우' do
      let!(:prev_user) { create(:user, password_digest: BCrypt::Password.create(password)) }

      before { params[:email] = prev_user.email }

      it_behaves_like 'Conflict 응답 처리', :request do
        let(:message) { '이미 가입된 이메일입니다' }
      end
    end

    context '이메일이 유효하지 않은 경우' do
      context '이메일 항목이 없는 경우' do
        before { params.except!(:email) }

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '올바른 이메일을 입력해주세요' }
        end
      end

      context '이메일 형식이 아닌 경우' do
        before { params[:email] = '1' }

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '올바른 이메일을 입력해주세요' }
        end
      end
    end

    context '비밀번호가 유효하지 않은 경우' do
      context '비밀번호 항목이 없는 경우' do
        before { params.except!(:password) }

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '올바른 비밀번호를 입력해주세요' }
        end
      end
    end

    context '유저 타입이 유효하지 않은 경우' do
      context '유저 타입 항목이 없는 경우' do
        before { params.except!(:userType) }

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '올바른 유저 타입을 입력해주세요' }
        end
      end

      context '유저 타입이 기사, 승객이 아닌 경우' do
        before { params[:userType] = '1' }

        it_behaves_like 'Bad Request 응답 처리', :request do
          let(:message) { '올바른 유저 타입을 입력해주세요' }
        end
      end
    end
  end

  describe '#sign_in' do
    def request
      post :sign_in, params: params
    end

    let(:user) { create(:user, password_digest: BCrypt::Password.create(password)) }

    context '올바른 요청인 경우' do
      let(:params) { { email: user.email, password: password } }

      it_behaves_like 'OK 응답 처리', :request

      it '응답이 생성된 토큰을 포함한다' do
        request
        expect(subject['accessToken']).to_not be_nil
        expect(subject['accessToken']).to eq(User.last.token)
      end
    end

    context '비밀번호가 유효하지 않은 경우' do
      let(:params) { { email: user.email } }

      let(:message) { '아이디와 비밀번호를 확인해주세요' }

      context '비밀번호가 틀린 경우' do
        before { params[:password] = 'hi' }

        it_behaves_like 'Bad Request 응답 처리', :request
      end

      context '비밀번호 항목이 없는 경우' do
        it_behaves_like 'Bad Request 응답 처리', :request
      end
    end
  end
end
