class AddResourceRefToBookmarks < ActiveRecord::Migration[6.1]
  def change
    add_reference :bookmarks, :resource, foreign_key: true, null: true
  end
end
