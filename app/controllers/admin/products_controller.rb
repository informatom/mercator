class Admin::ProductsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :number

  def index
    self.this = Product.paginate(:page => params[:page])
                       .search(params[:search], :title_de, :title_en, :number)
                       .order_by(parse_sort_param(:title_de, :title_en, :this, :number))
    hobo_index
  end
end