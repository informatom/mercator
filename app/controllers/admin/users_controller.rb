class Admin::UsersController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all

  autocomplete :name
end
