# frozen_string_literal: true

class ScheduleDayChangeRequest < ChangeRequest
	def self.modify_schedule_day_hours(field_change_hash, schedule_id, object_id)
		object_id ||= ''
		schedule_day = ScheduleDay.find_by(id: object_id) || ScheduleDay.new(schedule_id: schedule_id)
      	if field_change_hash["opens_at"] == nil && field_change_hash["closes_at"] == nil #delete schedule_day
        	schedule_day.destroy
      	else
        	schedule_day.update field_change_hash #add/change schedule_day hours
      	end
	end
end
