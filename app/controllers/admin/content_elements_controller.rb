class Admin::ContentElementsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def index
    if params[:search].present?
      @search = params[:search].split(" ").map{|word| "%" + word + "%"}
      self.this = ContentElement.paginate(:page => params[:page])
                                .where{(name_de.matches_any my{@search}) |
                                       (name_en.matches_any my{@search})}
                                .order_by(parse_sort_param(:name_de, :name_en, :this))
    else
      self.this = ContentElement.paginate(:page => params[:page])
                                .order_by(parse_sort_param(:name_de, :name_en, :this))
    end
    hobo_index
  end
end