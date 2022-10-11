# frozen_string_literal: true

FactoryBot.define do
  factory :taxi_request do
    passenger
    address           { Faker::Address.full_address }
    status            { 'standBy' }
    created_at        { Time.zone.now - 1.month }
    updated_at        { Time.zone.now - 1.month }
  end
end
