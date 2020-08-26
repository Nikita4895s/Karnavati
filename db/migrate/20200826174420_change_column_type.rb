class ChangeColumnType < ActiveRecord::Migration[6.0]
  def change
  	change_column :cello_masters, :capacity, :string
  end
end
