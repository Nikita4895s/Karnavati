class AddProductImageToCelloMasters < ActiveRecord::Migration[6.0]
  def change
    add_column :cello_masters, :product_image, :string
  end
end
