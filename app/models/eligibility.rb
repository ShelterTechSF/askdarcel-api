# frozen_string_literal: true

class Eligibility < ApplicationRecord
  has_and_belongs_to_many :services
end
