# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
  end
end
