class Admin::PropertyGroupsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all
  autocomplete
end