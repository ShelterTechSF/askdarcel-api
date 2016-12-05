class ChangeRequest < ActiveRecord::Base
  enum status: { pending: 0, approved: 1, rejected: 2 }

  has_many :field_changes
end
