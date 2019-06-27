# frozen_string_literal: true

FactoryBot.define do
  factory :eligibility do
    # 'eligibility-a', 'eligibility-b', etc.
    sequence(:name, 'a') { |n| "eligibility-#{n}" }
  end
end
