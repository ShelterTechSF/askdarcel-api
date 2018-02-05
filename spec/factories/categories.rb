# frozen_string_literal: true

FactoryGirl.define do
  factory :category do
    name { Faker::Company.name }
  end
end
