class AddDescriptionToPhones < ActiveRecord::Migration[5.0]
  def change
    add_column :phones, :description, :string
  end
end
