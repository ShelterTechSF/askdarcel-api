class AddCertifiedToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :certified, :boolean, default: false
  end
end
