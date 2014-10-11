class Admin::WebpagesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :name, :query_scope => [:title_de_contains]

  index_action :treereorder do
    @this = @webpages = Webpage.roots.paginate(:page => 1, :per_page => Webpage.count)
    @webpagesarray = childrenarray(webpages: @webpages).to_json
  end

  index_action :do_treereorder do
    @webpgaes = Webpage.all
    parse_webpages(webpages: params[:webpages], parent_id: nil)
    if request.xhr?
      hobo_ajax_response
    end
  end

  def show
    @this = Webpage.friendly.find(params[:id])
    hobo_show
  end

  def edit
    @this = Webpage.friendly.find(params[:id])
    hobo_edit
  end

  def update
    self.this = Webpage.friendly.find(params[:id])
    hobo_update
  end

  def destroy
    @this = Webpage.friendly.find(params[:id])
    hobo_destroy
  end

  def index
    if params[:search].present?
      @search = params[:search].split(" ").map{|word| "%" + word + "%"}
      self.this = Webpage.paginate(:page => params[:page])
                          .where{(title_de.matches_any my{@search}) |
                                 (title_en.matches_any my{@search}) |
                                 (state.matches_any my{@search})}
                         .order_by(parse_sort_param(:title_de, :title_en, :state, :url, :position, :slug, :this))
    else
      self.this = Webpage.paginate(:page => params[:page])
                         .order_by(parse_sort_param(:title_de, :title_en, :state, :url, :position, :slug, :this))
    end
    hobo_index
  end

protected
  def parse_webpages(webpages: nil, parent_id: nil)
    webpages.each do |position, webpages|
      webpage = Webpage.find(webpages["key"])
      if webpage.position != position.to_i || webpage.parent_id != parent_id
        webpage.update(position: position, parent_id: parent_id)
      end
      parse_webpages(webpages: webpages["children"], parent_id: webpage.id) if webpages["children"]
    end
  end

  def childrenarray(webpages: nil)
    childrenarray = []
    webpages.each do |webpage|
      childhash = Hash["title"  => webpage.name, "key" => webpage.id, "folder" => true]
      if webpage.children.any?
        childhash["children"] = childrenarray(webpages: webpage.children)
      end
      childrenarray << childhash
    end
    return childrenarray
  end
end