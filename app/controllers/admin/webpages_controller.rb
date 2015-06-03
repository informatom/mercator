class Admin::WebpagesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :name, :query_scope => [:title_de_contains]


  def index
    if params[:search].present?
      @search = params[:search].split(" ").map{|word| "%" + word + "%"}
      self.this = @webpages = Webpage.paginate(:page => params[:page])
                                     .where{(title_de.matches_any my{@search}) |
                                            (title_en.matches_any my{@search}) |
                                            (state.matches_any my{@search})}
                                    .order_by(parse_sort_param(:title_de, :title_en, :state, :url, :position, :slug, :this))
    else
      self.this = @webpages = Webpage.paginate(:page => params[:page])
                                     .order_by(parse_sort_param(:title_de, :title_en, :state, :url, :position, :slug, :this))
    end
    hobo_index
  end


  def show
    self.this = @webpage = Webpage.friendly.find(params[:id])
    hobo_show
  end


  def create
    hobo_create(redirect: contentmanager_front_path) do
      session[:selected_webpage_id] = this.id
    end
  end


  def edit
    self.this = @webpage = Webpage.friendly.find(params[:id])
    hobo_edit do
      session[:selected_webpage_id] = this.id
    end
  end


  def update
    self.this = @webpage = Webpage.friendly.find(params[:id])
    hobo_update(redirect: contentmanager_front_path) do
      session[:selected_webpage_id] = this.id
    end
  end


  def destroy
    begin
      self.this = @webpage = Webpage.friendly.find(params[:id])
    rescue
      render :text => I18n.t("mercator.content_manager.cannot_delete_webpage.record_not_found"),
             :status => 403 and return
    end

    if @webpage.children.any?
      render :text => I18n.t("mercator.content_manager.cannot_delete_webpage.subpages"),
      :status => 403 and return
    end

    hobo_destroy do
      render nothing: true if request.xhr?
    end
  end


  def do_publish
    do_transition_action :publish, redirect: contentmanager_front_path do
      session[:selected_webpage_id] = this.id
    end
  end


  def do_archive
    do_transition_action :archive, redirect: contentmanager_front_path do
      session[:selected_webpage_id] = this.id
    end
  end


  def do_hide
    do_transition_action :hide, redirect: contentmanager_front_path do
      session[:selected_webpage_id] = this.id
    end
  end


  def do_unhide
    do_transition_action :unhide, redirect: contentmanager_front_path do
      session[:selected_webpage_id] = this.id
    end
  end
end