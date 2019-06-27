# frozen_string_literal: true

namespace :migrate do
  desc 'Migrate schedule days from original columns to new datetime columns'
  task migrate_schedule_days: :environment do
    DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze
    def find_next_day(day)
      day_ix = DAYS.find_index(day)
      day_ix < 6 ? DAYS[day_ix + 1] : DAYS[0]
    end

    ScheduleDay.all.each do |sch|
      # if open time greater than close time - close day should be day after open day
      close_day = if sch.opens_at && sch.closes_at && (sch.opens_at > sch.closes_at)
                    find_next_day(sch.day)
                  else
                    sch.day
                  end

      o_t = sch.opens_at.to_s.rjust(4, "0")
      new_opens_at = "#{o_t[0..1]}:#{o_t[2..-1]}"
      c_t = sch.closes_at.to_s.rjust(4, "0")
      new_closes_at = "#{c_t[0..1]}:#{c_t[2..-1]}"

      sch.update!(
        open_day: sch.day,
        open_time: new_opens_at,
        close_day: close_day,
        close_time: new_closes_at
      )
    end
  end
end
