class ChangeColumnNamePhoneType < ActiveRecord::Migration[6.1]
  def change
    rename_column :phones, :type, :service_type
  end
end
