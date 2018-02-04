class AddFundingToServices < ActiveRecord::Migration[5.0]
  def change
    add_reference :services, :funding, foreign_key: true
  end
end
