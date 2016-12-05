class CreateChangeRequest < ActiveRecord::Migration[5.0]
  def change
    create_table :change_requests do |t|
      t.timestamps null: false

      t.string :type
      t.integer :object_id
	    t.column :status, :integer, default: 0

    end
  end
end
