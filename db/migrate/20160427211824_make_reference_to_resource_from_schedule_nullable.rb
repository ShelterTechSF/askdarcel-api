class MakeReferenceToResourceFromScheduleNullable < ActiveRecord::Migration
  def change
    change_column_null :schedules, :resource_id, true
  end
end
