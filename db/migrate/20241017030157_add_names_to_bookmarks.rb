class AddNamesToBookmarks < ActiveRecord::Migration[6.1]
  def change
    add_column :bookmarks, :name, :string, null: true
  end
end
