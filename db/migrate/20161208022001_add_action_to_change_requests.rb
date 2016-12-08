class AddActionToChangeRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :change_requests, :action, :integer, default: 1
  end
end
