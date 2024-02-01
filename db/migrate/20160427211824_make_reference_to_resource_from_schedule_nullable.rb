class MakeReferenceToResourceFromScheduleNullable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :schedules, :resource_id, true
  end
end
