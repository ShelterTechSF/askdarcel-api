class CreatePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :permissions do |t|
      t.integer :action
      t.references :resource, foreign_key: true
      t.references :service, foreign_key: true

      t.timestamps
    end

    add_index :permissions, [:service_id, :action], unique: true
    add_index :permissions, [:resource_id, :action], unique: true

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE permissions
          ADD CONSTRAINT resource_xor_service
          CHECK (
            (resource_id IS NOT NULL AND service_id IS NULL) OR
            (resource_id IS NULL AND service_id IS NOT NULL)
          )
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE permissions
          DROP CONSTRAINT resource_xor_service
        SQL
      end
    end

  end
end
