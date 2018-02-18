# frozen_string_literal: true

FactoryGirl.define do
  factory :note do
    note { Faker::Lorem.paragraph }
    resource nil
    service nil
  end
end
