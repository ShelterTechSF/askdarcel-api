class AddFeaturedToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :featured, :boolean
  end
end
