class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.timestamps null: false

      t.references :resource, index: true, foreign_key: true, null: false
    end
  end
end
