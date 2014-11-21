class Admin::ProductsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all, :new

  autocomplete :number

  def index
    if params[:search].present?
      @search = params[:search].split(" ").map{|word| "%" + word + "%"}
      self.this = Product.paginate(:page => params[:page])
                          .where{(title_de.matches_any my{@search}) |
                                 (title_en.matches_any my{@search}) |
                                 (state.matches_any my{@search}) |
                                 (number.matches_any my{@search}) }
                         .order_by(parse_sort_param(:title_de, :title_en, :this, :number, :state))
    else
      self.this = Product.paginate(:page => params[:page])
                         .order_by(parse_sort_param(:title_de, :title_en, :this, :number, :state))
    end
    hobo_index
  end
end