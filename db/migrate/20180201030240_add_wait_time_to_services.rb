class AddWaitTimeToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :wait_time, :string
  end
end
