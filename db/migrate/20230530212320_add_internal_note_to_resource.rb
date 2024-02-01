class AddInternalNoteToResource < ActiveRecord::Migration[6.1]
  def change
    add_column :resources, :internal_note, :text
  end
end
