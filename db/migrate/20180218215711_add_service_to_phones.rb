class AddServiceToPhones < ActiveRecord::Migration[5.0]
  def change
    add_reference :phones, :service, foreign_key: true
  end
end
