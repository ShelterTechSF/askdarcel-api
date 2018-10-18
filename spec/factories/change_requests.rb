# frozen_string_literal: true

FactoryBot.define do
  factory :change_request do
    after :create do |change_request|
      create(:field_change, field_name: 'name', field_value: Faker::Company.name, change_request: change_request)
      create(
        :field_change,
        field_name: 'long_description',
        field_value: Faker::ShelterTech.description,
        change_request: change_request
      )
    end
  end
end
