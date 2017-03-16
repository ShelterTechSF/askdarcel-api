class AddEmailToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :email, :string
  end
end
