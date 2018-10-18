# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email { 'dev-admin@sheltertech.org' }
    password { 'dev-test-01' }
  end
end
