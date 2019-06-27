class AddFeaturedToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :featured, :boolean
  end
end
