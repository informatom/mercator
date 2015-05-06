class CountriesController < ApplicationController
  hobo_model_controller

  autocomplete :name_de
end