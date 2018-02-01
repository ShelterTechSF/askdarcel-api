class AddLegalStatusToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :legal_status, :string
  end
end
