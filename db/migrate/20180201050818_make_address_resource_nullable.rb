class MakeAddressResourceNullable < ActiveRecord::Migration[5.0]
  def change
  	change_column_null :addresses, :resource_id, true
  end
end
