FactoryBot.define do
  factory :taxi_request do
    passenger
    driver_id         {  }
    address           { Faker::Address.full_address }
    status            { 1 }
    created_at        { Time.now - 1.months }
    updated_at        { Time.now - 1.months }
  end
end