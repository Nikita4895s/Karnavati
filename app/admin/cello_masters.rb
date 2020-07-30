ActiveAdmin.register CelloMaster do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :company_name, :divison, :category, :product_name, :capacity, :mrp, :drp, :trade_discount, :rate, :scheme, :net_rate, :link_url
  #
  # or
  #
  # permit_params do
  #   permitted = [:company_name, :divison, :category, :product_name, :capacity, :mrp, :drp, :trade_discount, :rate, :scheme, :net_rate, :link_url]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
