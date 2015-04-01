class Sales::ProductsController < Sales::SalesSiteController

  hobo_model_controller
  autocomplete :number, {:query_scope => :active_and_number_contains, limit: 25}
end