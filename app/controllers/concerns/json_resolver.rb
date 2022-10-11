# frozen_string_literal: true

module JsonResolver
  extend ActiveSupport::Concern

  def json_success(data = {}, status = 200)
    render json: data, status: status
  end

  def json_create_success(data = {})
    json_success(data, 201)
  end
end
