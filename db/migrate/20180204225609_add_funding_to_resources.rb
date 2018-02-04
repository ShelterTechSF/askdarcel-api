class AddFundingToResources < ActiveRecord::Migration[5.0]
  def change
    add_reference :resources, :funding, foreign_key: true
  end
end
