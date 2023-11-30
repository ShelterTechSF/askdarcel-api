class CreateBookmarksModel < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.integer :rank
      t.references :folder, foreign_key: true
      t.references :service, foreign_key: true
      t.timestamps
    end
  end
end
