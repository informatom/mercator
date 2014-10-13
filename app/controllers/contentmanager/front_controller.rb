class Contentmanager::FrontController < Contentmanager::ContentmanagerSiteController

  hobo_controller

  def index
    @webpagesarray = childrenarray(webpages: Webpage.roots).to_json
  end

  def update_webpages
    @webpgaes = Webpage.all
    reorder_webpages(webpages: params[:webpages], parent_id: nil)
    if request.xhr?
      hobo_ajax_response
    end
  end

  def show_webpage
    @webpage = Webpage.find(params[:id])
    @page_template = @webpage.page_template
    render json: [@webpage, @page_template]
  end

protected

  def reorder_webpages(webpages: nil, parent_id: nil)
    webpages.each do |position, webpages|
      webpage = Webpage.find(webpages["key"])
      if webpage.position != position.to_i || webpage.parent_id != parent_id
        webpage.update(position: position, parent_id: parent_id)
      end
      reorder_webpages(webpages: webpages["children"], parent_id: webpage.id) if webpages["children"]
    end
  end

  def childrenarray(webpages: nil)
    childrenarray = []
    webpages.each do |webpage|
      childhash = Hash["title"  => webpage.name, "key" => webpage.id, "folder" => false]
      if webpage.children.any?
        childhash["children"] = childrenarray(webpages: webpage.children)
      end
      childrenarray << childhash
    end
    return childrenarray
  end
end