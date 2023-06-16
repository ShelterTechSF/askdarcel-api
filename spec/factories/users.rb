# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  name         :string
#  is_superuser :boolean          default(FALSE)
#
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
  end
end
