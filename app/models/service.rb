# frozen_string_literal: true

class Service < ActiveRecord::Base
  enum status: { pending: 0, approved: 1, rejected: 2, inactive: 3 }

  belongs_to :resource, required: true, touch: true
  has_many :notes, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_and_belongs_to_many :categories
  has_many :ratings, dependent: :destroy
  has_and_belongs_to_many :eligibilities, dependent: :destroy

  accepts_nested_attributes_for :notes
  accepts_nested_attributes_for :schedule

  before_create do
    self.status = :pending unless status
  end
end
