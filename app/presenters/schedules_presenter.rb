class SchedulesPresenter < Jsonite
  property :id
  property :schedule_days, with: ScheduleDaysPresenter
end
