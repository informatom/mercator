class Admin::ProductsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :number

  def index
    self.this = Product.paginate(:page => params[:page]).search(params[:search], :title_de, :number).order_by(parse_sort_param(:title, :quantity))
    hobo_index
  end
end