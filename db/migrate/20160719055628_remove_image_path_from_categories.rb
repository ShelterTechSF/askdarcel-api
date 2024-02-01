class RemoveImagePathFromCategories < ActiveRecord::Migration[6.1]
  def change
    remove_column :categories, :image_path
  end
end
