class CreateFieldChange < ActiveRecord::Migration[5.0]
  def change
    create_table :field_changes do |t|
      t.string :field_name
      t.string :field_value
      t.references :change_request, index: true, foreign_key: true, null: false
    end
  end
end
