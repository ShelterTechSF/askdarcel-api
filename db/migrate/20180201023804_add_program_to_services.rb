class AddProgramToServices < ActiveRecord::Migration[5.0]
  def change
    add_reference :services, :program, foreign_key: true
  end
end
