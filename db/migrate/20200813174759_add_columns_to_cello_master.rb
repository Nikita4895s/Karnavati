class AddColumnsToCelloMaster < ActiveRecord::Migration[6.0]
  def change
    add_column :cello_masters, :hsn_no, :string
    add_column :cello_masters, :product_mode, :integer
    add_column :cello_masters, :arrival_date, :date
    add_column :cello_masters, :product_code, :string
    add_column :cello_masters, :gst_per, :decimal
    add_column :cello_masters, :rate, :decimal
  end
end
