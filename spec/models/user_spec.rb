# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  describe 'validations' do
    it { should validate_length_of(:email).is_at_most(100) }
  end

  describe '#password' do
    context '비밀번호를 변경하는 경우' do
      let(:password) { 'password' }

      before do
        user.password = password
        user.save!
      end

      it '변경된 비밀번호로 인증 잘 된다' do
        expect(user.authenticate(password).present?).to eq(true)
      end
    end
  end
end
