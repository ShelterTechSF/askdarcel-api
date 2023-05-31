class CreatePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :permissions do |t|
      t.string :description
      t.string :permission, null: false
      t.string :object_type, null: false
      t.bigint :object_pk, null: false

      t.timestamps
    end
  end
end
