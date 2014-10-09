class Admin::PropertiesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def do_filter
    do_transition_action :filter do
      category = Category.find(params[:category_id])
      category.update_property_hash
      redirect_to edit_properties_admin_category_path(category)
    end
  end

  def do_dont_filter
    do_transition_action :dont_filter do
      category = Category.find(params[:category_id])
      category.update_property_hash
      redirect_to edit_properties_admin_category_path(category)
    end
  end
end