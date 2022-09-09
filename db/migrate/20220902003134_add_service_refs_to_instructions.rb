class AddServiceRefsToInstructions < ActiveRecord::Migration[6.1]
  def change
    add_reference :instructions, :service, foreign_key: true
  end
end
