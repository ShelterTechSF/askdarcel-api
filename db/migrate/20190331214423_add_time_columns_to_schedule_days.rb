class AddTimeColumnsToScheduleDays < ActiveRecord::Migration[5.0]
  def change
    add_column :schedule_days, :open_time, :time
    add_column :schedule_days, :open_day, :string
    add_column :schedule_days, :close_time, :time
    add_column :schedule_days, :close_day, :string
  end
end
