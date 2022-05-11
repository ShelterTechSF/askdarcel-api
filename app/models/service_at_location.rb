# frozen_string_literal: true

# Join table between `categories` and `services`.
class ServiceAtLocation < ApplicationRecord
  belongs_to :service
  belongs_to :address
  belongs_to :schedule
end