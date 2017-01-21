class AddResourceToChangeRequests < ActiveRecord::Migration[5.0]
  def change
    add_reference :change_requests, :resource, foreign_key: true
  end
end
