class AddShortDescriptionToService < ActiveRecord::Migration[6.1]
  def change
    add_column :services, :short_description, :string
  end
end
