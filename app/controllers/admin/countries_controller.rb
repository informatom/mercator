class Admin::CountriesController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all

  autocomplete :name_de

end