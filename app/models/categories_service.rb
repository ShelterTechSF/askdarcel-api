# frozen_string_literal: true

# Join table between `categories` and `services`.
class CategoriesService < ApplicationRecord
  belongs_to :category
  belongs_to :service
end
