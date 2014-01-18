class Admin::WebpagesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  autocomplete :name, :query_scope => [:title_de_contains]

  index_action :treereorder do
    @this = Page.roots.paginate(:page => 1, :per_page => Page.count)
  end

  index_action :do_treereorder do
    pages_array = ActiveSupport::JSON.decode(params[:pages])
    parse_pages(pages_array, nil)
    if request.xhr?
      hobo_ajax_response
    end
  end

protected
  def parse_pages(pages_array, parent)
    pages_array.each_with_index do |page_hash, position|
      page = Page.find(page_hash["id"])
      page.update_attributes(position: position, parent_id: parent)
      parse_pages(page_hash["children"], page.id) if page_hash["children"]
    end
  end
end