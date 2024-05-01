class MakeCategoriesHierarchical < ActiveRecord::Migration[6.1]
  def change
    add_column :eligibilities, :parent_id, :integer, null: true, index: true
    add_foreign_key :eligibilities, :eligibilities, column: :parent_id
  end
end
