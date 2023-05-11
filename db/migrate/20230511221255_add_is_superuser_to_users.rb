class AddIsSuperuserToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_superuser, :boolean
  end
end
