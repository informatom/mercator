class Admin::ContentElementsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :name_de

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

  def update
    hobo_update do
      redirect_to contentmanager_front_path
      session[:selected_content_element_id] = this.id
      session[:selected_folder_id] = this.folder.id
    end
  end
end