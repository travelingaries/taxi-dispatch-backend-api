FactoryBot.define do
  factory :taxi_request do
    passenger_id      { Faker::Number.digit.to_i }
    driver_id         { Faker::Number.digit.to_i }
    address           { Faker::Address.full_address }
    status            { 1 }
    created_at        { Time.now - 1.months }
    updated_at        { Time.now - 1.months }
  end
end