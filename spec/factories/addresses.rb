# frozen_string_literal: true

FactoryGirl.define do
  factory :address do
    resource nil
    attention { Faker::Name.name }
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    address_3 nil
    address_4 nil
    city { Faker::Address.city }
    state_province { Faker::Address.state }
    postal_code { Faker::Address.postcode }
    latitude { Faker::Number.between(37.78, 37.80) }
    longitude { Faker::Number.between(-122.41, -122.39) }
    country "USA"
  end
end
