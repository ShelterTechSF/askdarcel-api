class AddDescriptionToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :description, :text
  end
end
