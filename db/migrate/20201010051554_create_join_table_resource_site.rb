class CreateJoinTableResourceSite < ActiveRecord::Migration[6.1]
  def change
    create_join_table :resources, :sites, column_options: { null: false, foreign_key: true } do |t|
      t.index [:resource_id, :site_id]
      t.index [:site_id, :resource_id]
    end
  end
end
