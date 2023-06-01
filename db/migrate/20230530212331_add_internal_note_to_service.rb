class AddInternalNoteToService < ActiveRecord::Migration[6.1]
  def change
    add_column :services, :internal_note, :text
  end
end
