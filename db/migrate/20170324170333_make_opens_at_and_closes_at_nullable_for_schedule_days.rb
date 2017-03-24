class MakeOpensAtAndClosesAtNullableForScheduleDays < ActiveRecord::Migration[5.0]
  def change
  	change_column :schedule_days, :opens_at, :integer, :null => true
  	change_column :schedule_days, :closes_at, :integer, :null => true
  end
end
