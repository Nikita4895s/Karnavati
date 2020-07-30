class ChangeCelloMaster < ActiveRecord::Migration[6.0]
  def change
    add_column :cello_masters, :discount, :decimal
    remove_column :cello_masters, :trade_discount
    remove_column :cello_masters, :rate
    remove_column :cello_masters, :scheme
    remove_column :cello_masters, :net_rate
  end
end
