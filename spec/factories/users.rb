# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id   :integer          not null, primary key
#  name :string
#
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    organization { Faker::Company.name }
    user_external_id { Faker::Alphanumeric.alpha(number: 10) }
    email { Faker::Internet.email(domain: "example.com") }
  end
end
