# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    resource { nil }
    attention { Faker::Name.name }
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    address_3 { nil }
    address_4 { nil }
    city { Faker::Address.city }
    state_province { Faker::Address.state }
    postal_code { Faker::Address.postcode }
    latitude { Faker::Number.between(from: 37.78, to: 37.80) }
    longitude { Faker::Number.between(from: -122.41, to: -122.39) }
  end
end
