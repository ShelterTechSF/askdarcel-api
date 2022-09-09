# frozen_string_literal: true

FactoryBot.define do
    factory :news do
        id { 0 }
        headline { Faker::Lorem.sentence }
        effective_date { Time.current }
        body { Faker::Lorem.paragraphs(number: 4) }
        priority { 1 }
        expiration_date { nil }
    end
  end
  