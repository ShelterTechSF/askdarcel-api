class AddOnlineToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :online, :boolean
  end
end
