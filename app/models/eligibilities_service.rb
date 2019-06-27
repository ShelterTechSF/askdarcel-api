# frozen_string_literal: true

class EligibilitiesService < ApplicationRecord
  belongs_to :eligibilities
  belongs_to :services
end
