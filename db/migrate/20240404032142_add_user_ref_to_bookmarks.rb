class AddUserRefToBookmarks < ActiveRecord::Migration[6.1]
  def change
    add_reference :bookmarks, :user, foreign_key: true, null: true
  end
end
