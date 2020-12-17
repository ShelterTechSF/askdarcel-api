# frozen_string_literal: true

FactoryBot.define do
  factory :texting_recipient do
    recipient_name { "MyString" }
    phone_number { "MyString" }
  end
end
