class AddColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :organization, :string
    add_column :users, :user_external_id, :string
    add_column :users, :email, :string
    add_index :users, :email, unique: true
  end
end
