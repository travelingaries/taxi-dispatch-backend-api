FactoryBot.define do
  factory :user, class: User::Passenger do
    email             { Faker::Internet.unique.email }
    password_digest   { Faker::Internet.password }
    token             { SecureRandom.hex(30) }
    created_at        { Time.now - 2.months }
    updated_at        { Time.now - 1.months }
  end
end