class AddCertifiedAtToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :certified_at, :timestamp
  end
end
