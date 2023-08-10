class AddChildPriorityRankColumnToCategoryRelationships < ActiveRecord::Migration[6.1]
  def change
    add_column :category_relationships, :child_priority_rank, :integer
    add_index(:category_relationships, [:child_id, :parent_id], :unique => true)
  end
end
