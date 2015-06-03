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


  def new
    if params[:folder]
      self.this = @content_element = ContentElement.new()
      self.this.folder_id = params[:folder]
    end
    hobo_new
  end


  def create
    hobo_create(redirect: contentmanager_front_path) do
      session[:selected_content_element_id] = this.id
      session[:selected_folder_id] = this.folder.id if this.folder
    end
  end


  def edit
    hobo_edit do
      session[:selected_content_element_id] = this.id
      session[:selected_folder_id] = this.folder.id if this.folder
    end
  end


  def update
    hobo_update(redirect: contentmanager_front_path) do
      session[:selected_content_element_id] = this.id
      session[:selected_folder_id] = this.folder.id if this.folder
    end
  end


  def destroy
    hobo_destroy do
      render nothing: true if request.xhr?
    end
  end
end
