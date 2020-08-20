ActiveAdmin.register CelloMaster do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :company_name, :divison, :category, :product_name,
    :capacity, :mrp, :drp, :discount, :rate, :link_url, :hsn_no, :product_mode,
    :arrival_date, :product_code, :gst_per
  
end
