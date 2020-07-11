class CreateCelloMasters < ActiveRecord::Migration[6.0]
  def change
    create_table :cello_masters do |t|
      t.string :company_name
      t.string :divison
      t.string :category
      t.string :product_name
      t.string :capacity
      t.decimal :mrp
      t.decimal :drp
      t.decimal :trade_discount
      t.decimal :rate
      t.decimal :scheme
      t.decimal :net_rate

      t.timestamps
    end
  end
end
