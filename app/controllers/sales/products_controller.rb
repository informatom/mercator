class Sales::ProductsController < Sales::SalesSiteController

  hobo_model_controller
  autocomplete :number
end