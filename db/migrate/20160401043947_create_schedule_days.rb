class CreateScheduleDays < ActiveRecord::Migration[6.1]
  def change
    create_table :schedule_days do |t|
      t.timestamps null: false

      t.string :day, null: false
      t.integer :opens_at, null: false
      t.integer :closes_at, null: false
      t.references :schedule, index: true, foreign_key: true, null: false
    end
  end
end
