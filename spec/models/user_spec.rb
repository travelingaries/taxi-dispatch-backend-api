# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  describe 'validations' do
    it { should validate_length_of(:email).is_at_most(100) }
  end
end
