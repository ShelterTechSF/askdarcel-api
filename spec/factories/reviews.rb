# frozen_string_literal: true

FactoryGirl.define do
  factory :review do
    review { Faker::Lorem.paragraph }
    rating nil
  end
end
