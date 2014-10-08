class Admin::PropertiesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def do_filter
    do_transition_action :filter do
      redirect_to edit_properties_admin_category_path(params[:category_id])
    end
  end

  def do_dont_filter
    do_transition_action :dont_filter do
      redirect_to edit_properties_admin_category_path(params[:category_id])
    end
  end
end