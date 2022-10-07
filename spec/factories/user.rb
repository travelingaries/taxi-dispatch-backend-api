# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    type              { User::Passenger.name }
    email             { Faker::Internet.unique.email }
    password          { Faker::Internet.password }
    token             { SecureRandom.hex(30) }
    created_at        { Time.zone.now - 2.months }
    updated_at        { Time.zone.now - 1.month }

    trait :driver do
      type { User::Driver.name }
    end

    factory :passenger, class: User::Passenger
    factory :driver, class: User::Driver, traits: [:driver]
  end
end
