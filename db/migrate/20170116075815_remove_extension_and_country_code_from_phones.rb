class RemoveExtensionAndCountryCodeFromPhones < ActiveRecord::Migration[5.0]
  def change
    remove_column :phones, :extension, :string
    remove_column :phones, :country_code, :string
  end
end
