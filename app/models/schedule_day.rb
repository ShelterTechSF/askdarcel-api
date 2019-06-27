# frozen_string_literal: true

class ScheduleDay < ActiveRecord::Base
  belongs_to :schedule
  validates_presence_of :opens_at, :closes_at
end
