class CreateSynonymGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :synonym_groups do |t|
      t.integer :group_type

      t.timestamps
    end
    add_index :synonym_groups, :group_type
  end
end
