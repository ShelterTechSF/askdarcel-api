class Resource < ActiveRecord::Base
  enum status: { pending: 0, approved: 1, rejected: 2, inactive: 3 }

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :keywords
  has_one :address, dependent: :destroy
  has_many :phones, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :change_requests, dependent: :destroy

  accepts_nested_attributes_for :notes
  accepts_nested_attributes_for :schedule

  before_create do
    self.status = :pending unless status
  end
end
