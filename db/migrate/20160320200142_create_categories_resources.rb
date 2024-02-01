class CreateCategoriesResources < ActiveRecord::Migration[6.1]
  def change
    create_join_table :categories, :resources do |t|
      t.index :category_id
      t.index :resource_id
    end
  end
end
