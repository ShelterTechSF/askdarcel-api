class CreateTextings < ActiveRecord::Migration[5.2]
  def change
    create_table :textings do |t|
      t.references :texting_recipient, index: true, foreign_key: true, null: false
      t.references :service, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
