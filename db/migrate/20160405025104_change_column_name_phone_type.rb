class ChangeColumnNamePhoneType < ActiveRecord::Migration
  def change
    rename_column :phones, :type, :service_type
  end
end
