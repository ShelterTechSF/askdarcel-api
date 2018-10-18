# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    note { Faker::Lorem.paragraph }
    resource { nil }
    service { nil }
  end
end
