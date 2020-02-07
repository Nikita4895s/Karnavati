class AddColumnLinkUrlToCelloMaster < ActiveRecord::Migration[6.0]
  def change
  	add_column :cello_masters, :link_url, :text
  end
end
