# frozen_string_literal: true

FactoryBot.define do
  factory :folder do
    name { Faker::Company.name }
  end
end
