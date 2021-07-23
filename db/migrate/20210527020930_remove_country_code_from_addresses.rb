class RemoveCountryCodeFromAddresses < ActiveRecord::Migration[5.2]
  def change
    remove_column :addresses, :country, :string
  end
end
