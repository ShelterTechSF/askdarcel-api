class DeviseTokenAuthCreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table(:admins) do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## User Info
      t.string :email

      ## Tokens
      t.json :tokens

      t.timestamps
    end
    add_index :admins, :email
    add_index :admins, [:uid, :provider],     :unique => true
  end
end