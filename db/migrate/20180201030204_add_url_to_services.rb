class AddUrlToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :url, :string
  end
end
