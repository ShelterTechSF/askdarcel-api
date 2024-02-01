class AddServiceToSchedules < ActiveRecord::Migration[6.1]
  def change
    add_reference :schedules, :service, index: true, foreign_key: true
  end
end
