class ChangeFeeInServices < ActiveRecord::Migration[5.0]
  def change
    change_column :services, :fee, :string
  end
end
