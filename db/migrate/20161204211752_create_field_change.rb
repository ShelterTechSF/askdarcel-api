class CreateFieldChange < ActiveRecord::Migration[5.0]
  def change
    create_table :field_changes do |t|
      t.string :field_name
      t.string :field_value
    end
  end
end
