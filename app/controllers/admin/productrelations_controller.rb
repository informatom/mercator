class Admin::ProductrelationsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all, except: :index
end