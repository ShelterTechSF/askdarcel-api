# frozen_string_literal: true

FactoryBot.define do
  factory :saved_search do
    name { Faker::Company.name }
  end
end
