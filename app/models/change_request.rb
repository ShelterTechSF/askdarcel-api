class ChangeRequest < ActiveRecord::Base
  enum status: [ :pending, :approved, :rejected ]

  has_many :field_changes
end