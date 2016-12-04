class CreateChangeRequest < ActiveRecord::Migration[5.0]
  def change
    create_table :change_requests do |t|
      t.timestamps null: false

      t.string :object_name
      t.integer :object_id
      t.string :status
    end
  end
end
