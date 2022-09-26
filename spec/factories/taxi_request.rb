FactoryBot.define do
  factory :taxi_request do
    driver_id         {  }
    address           { Faker::Address.full_address }
    status            { 1 }
    created_at        { Time.now - 1.months }
    updated_at        { Time.now - 1.months }

    before(:create) do |taxi_request|
      passenger = create(:passenger)
      taxi_request.passenger = passenger
    end
  end
end