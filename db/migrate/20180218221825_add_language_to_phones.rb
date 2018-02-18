class AddLanguageToPhones < ActiveRecord::Migration[5.0]
  def change
    add_reference :phones, :language, foreign_key: true
  end
end
