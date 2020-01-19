class CreateSynonyms < ActiveRecord::Migration[5.2]
  def change
    create_table :synonyms do |t|
      t.string :word
      t.belongs_to :synonym_group, foreign_key: true

      t.timestamps
    end
    add_index :synonyms, :word
  end
end
