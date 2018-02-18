class AddTransportationToAddresses < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :transportation, :text
  end
end
