class Schedule < ActiveRecord::Base
  belongs_to :resource, touch: true
  belongs_to :service
  has_many :schedule_days
  has_one :note

  accepts_nested_attributes_for :schedule_days
end
