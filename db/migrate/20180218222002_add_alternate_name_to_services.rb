class AddAlternateNameToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :alternate_name, :string
  end
end
