class Admin::WebpagesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :name, :query_scope => [:title_de_contains]

  index_action :treereorder do
    @this = Webpage.roots.paginate(:page => 1, :per_page => Webpage.count)
  end

  index_action :do_treereorder do
    webpages_array = ActiveSupport::JSON.decode(params[:webpages])
    parse_webpages(webpages_array, nil)
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
  def parse_webpages(webpages_array, parent)
    webpages_array.each_with_index do |webpage_hash, position|
      webpage = Webpage.find(webpage_hash["id"])
      webpage.update(position: position, parent_id: parent)
      parse_webpages(webpage_hash["children"], webpage.id) if webpage_hash["children"]
    end
  end
end