class AddServiceToSchedules < ActiveRecord::Migration
  def change
    add_reference :schedules, :service, index: true, foreign_key: true
  end
end
