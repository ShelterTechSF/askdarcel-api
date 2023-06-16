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
  end
end
