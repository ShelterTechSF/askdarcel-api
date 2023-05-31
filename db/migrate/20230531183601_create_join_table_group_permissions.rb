class CreateJoinTableGroupPermissions < ActiveRecord::Migration[6.1]
  def change
    create_join_table :groups, :permissions, table_name: :group_permissions do |t|
      t.index [:group_id, :permission_id]
      t.index [:permission_id, :group_id]
    end
  end
end
