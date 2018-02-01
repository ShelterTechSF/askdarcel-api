class AddInterpretationServicesToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :interpretation_services, :string
  end
end
