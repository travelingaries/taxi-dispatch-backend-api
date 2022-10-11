# frozen_string_literal: true

class UserTokenSerializer < BaseSerializer
  attributes :accessToken

  delegate :token, to: :object

  alias accessToken token
end
