# frozen_string_literal: true

class ScheduleDaysPresenter < Jsonite
  property :id
  property :day
  property :opens_at
  property :closes_at
  property :open_time do
    open_time&.strftime('%H:%M:%S')
  end
  property :open_day
  property :close_time do
    close_time&.strftime('%H:%M:%S')
  end
  property :close_day
end
