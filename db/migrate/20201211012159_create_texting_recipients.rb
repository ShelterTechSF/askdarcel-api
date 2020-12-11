class CreateTextingRecipients < ActiveRecord::Migration[5.2]
  def change
    create_table :texting_recipients do |t|
      t.string :recipient_name
      t.string :phone_number

      t.timestamps
    end
  end
end
