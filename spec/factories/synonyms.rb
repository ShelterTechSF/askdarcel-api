# frozen_string_literal: true

FactoryBot.define do
  factory :synonym do
    word { "MyString" }
    synonym_group { nil }
  end
end
