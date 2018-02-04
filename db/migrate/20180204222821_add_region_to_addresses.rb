class AddRegionToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :region, :string
  end
end
