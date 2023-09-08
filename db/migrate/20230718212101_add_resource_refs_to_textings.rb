class AddResourceRefsToTextings < ActiveRecord::Migration[6.1]
  def change
    add_reference :textings, :resource, index: true, foreign_key: true, null: true
    change_column_null :textings, :service_id, true

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE textings
          ADD CONSTRAINT resource_xor_service
          CHECK (
            (resource_id IS NOT NULL AND service_id IS NULL) OR
            (resource_id IS NULL AND service_id IS NOT NULL)
          )
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE textings
          DROP CONSTRAINT resource_xor_service
        SQL
      end
    end
  end
end
