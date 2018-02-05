# frozen_string_literal: true

class ScheduleDay < ActiveRecord::Base
  belongs_to :schedule
end
