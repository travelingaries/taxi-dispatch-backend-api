FactoryBot.define do
  factory :user do
    type              { User::Passenger.name }
    email             { Faker::Internet.unique.email }
    password_digest   { Faker::Internet.password }
    token             { SecureRandom.hex(30) }
    created_at        { Time.now - 2.months }
    updated_at        { Time.now - 1.months }

    trait :driver do
      type { User::Driver.name }
    end

    factory :passenger, class: User::Passenger
    factory :driver, class: User::Driver, traits: [:driver]
  end
end