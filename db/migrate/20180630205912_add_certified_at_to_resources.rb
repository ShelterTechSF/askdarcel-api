class AddCertifiedAtToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :certified_at, :timestamp
  end
end
