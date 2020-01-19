class CreateJoinTableCategoryRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table "category_relationships", :id => false do |t|
      t.integer "parent_id", :null => false
      t.integer "child_id", :null => false
    end
  end
end
