# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    name { Faker::Company.name }
    status { :approved }
    resource { nil }
    after :create do |service|
      create(:note, service: service)
      create(:schedule, service: service)
    end
  end
end
