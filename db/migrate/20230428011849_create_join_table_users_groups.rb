class CreateJoinTableUsersGroups < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :groups, table_name: :user_groups do |t|
        t.index :user_id
        t.index :group_id
    end
  end
end
