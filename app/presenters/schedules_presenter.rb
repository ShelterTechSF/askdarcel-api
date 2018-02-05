# frozen_string_literal: true

class SchedulesPresenter < Jsonite
  property :id
  property :schedule_days, with: ScheduleDaysPresenter
end
