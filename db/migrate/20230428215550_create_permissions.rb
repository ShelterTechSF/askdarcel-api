class CreatePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :permissions do |t|
      t.string :permission # e.g., create, read, update, delete
      t.string :object_type # e.g. resource, service
      t.integer :object_pk
      t.references :user, index: true, foreign_key: true, null: false
      t.references :group, index: true, foreign_key: true, null: false

      t.timestamps
    end
  end
end
