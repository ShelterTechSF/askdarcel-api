# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    rating { Faker::Number.positive(1, 5) }
    user { nil }
    resource { nil }
    service { nil }

    after :create do |rating|
      create(:review, rating: rating)
    end
  end
end
