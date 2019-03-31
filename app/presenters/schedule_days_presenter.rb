# frozen_string_literal: true

class ScheduleDaysPresenter < Jsonite
  property :id
  property :day
  property :opens_at
  property :closes_at
  property (:open_time) do
  	if (open_time)
      open_time.strftime('%H:%M:%S')
    end
  end
  property :open_day
  property (:close_time) do
  	if (close_time)
      close_time.strftime('%H:%M:%S')
    end
  end
  property :close_day
end
