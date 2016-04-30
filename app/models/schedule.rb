class Schedule < ActiveRecord::Base
  belongs_to :resource
  belongs_to :service
  has_many :schedule_days
end
