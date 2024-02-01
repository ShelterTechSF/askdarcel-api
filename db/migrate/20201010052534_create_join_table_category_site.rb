class CreateJoinTableCategorySite < ActiveRecord::Migration[5.2]
  def change
    create_join_table :categories, :sites, column_options: { null: false, foreign_key: true } do |t|
      t.index [:category_id, :site_id]
      t.index [:site_id, :category_id]
    end
  end
end
