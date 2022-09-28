require "spec_helper"

describe User do
  let!(:user) { create(:user) }

  describe '#password' do
    context '비밀번호를 변경하는 경우' do
      let(:password) { 'password' }

      before(:each) do
        user.password = password
        user.save!
      end

      it '변경된 비밀번호로 인증 잘 된다' do
        expect(user.authenticate(password).present?).to eq(true)
      end
    end
  end
end
