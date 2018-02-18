# frozen_string_literal: true

class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource
  belongs_to :service
  has_one :review, dependent: :destroy

  validates :rating, numericality: {
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }
end
