class Admin::SupplyrelationsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all, except: :index
end