class AddEmailToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :email, :string
  end
end
