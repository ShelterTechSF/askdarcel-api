class AddImagePathToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :image_path, :string
  end
end
