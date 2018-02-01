class AddAlternateNameToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :alternate_name, :string
  end
end
