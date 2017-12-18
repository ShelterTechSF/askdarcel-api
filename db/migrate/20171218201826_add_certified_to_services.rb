class AddCertifiedToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :certified, :boolean, default: false
  end
end
