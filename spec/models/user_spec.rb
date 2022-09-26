require "spec_helper"

describe User do
  before(:each) do
    @user = create(:user)
  end

  describe 'password' do
    context 'has_secure_password' do
      it 'initial states' do
        expect(@user.attributes["password"]).to be_nil
        expect(@user.password).to be_nil
        expect(@user.password_confirmation).to be_nil
        expect(@user.password_digest.present?).to eq(true)
        expect(@user.password_digest.is_a?(String)).to eq(true)
      end

      it 'change password' do
        prev_password_digest = @user.password_digest
        password = 'password'
        @user.password = password
        expect(@user.valid?).to eq(true)

        @user.save!
        expect(@user.password_digest != prev_password_digest).to eq(true)
        expect(@user.authenticate(password).present?).to eq(true)
      end
    end
  end
end