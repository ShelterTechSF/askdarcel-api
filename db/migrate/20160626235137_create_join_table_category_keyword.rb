class CreateJoinTableCategoryKeyword < ActiveRecord::Migration[6.1]
  def change
    create_join_table :categories, :keywords do |t|
      # t.index [:category_id, :keyword_id]
      # t.index [:keyword_id, :category_id]
    end
  end
end
