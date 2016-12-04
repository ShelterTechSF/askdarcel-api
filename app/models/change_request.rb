class ChangeRequest < ActiveRecord::Base
  has_many :field_changes
end