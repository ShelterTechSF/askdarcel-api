class AddStatusToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :status, :integer
  end
end
