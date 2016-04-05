class Schedule < ActiveRecord::Base
  belongs_to :resource
  has_many :schedule_days
end
