class Admin::WebpagesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :name, :query_scope => [:title_de_contains]

  index_action :treereorder do
    @this = Webpage.roots.paginate(:page => 1, :per_page => Webpage.count)
  end

  index_action :do_treereorder do
    pages_array = ActiveSupport::JSON.decode(params[:pages])
    parse_pages(pages_array, nil)
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
    @this = Webpage.friendly.find(params[:id])
    hobo_update
  end

  def destroy
    @this = Webpage.friendly.find(params[:id])
    hobo_destroy
  end

protected
  def parse_pages(pages_array, parent)
    pages_array.each_with_index do |page_hash, position|
      page = Page.find(page_hash["id"])
      page.update(position: position, parent_id: parent)
      parse_pages(page_hash["children"], page.id) if page_hash["children"]
    end
  end
end