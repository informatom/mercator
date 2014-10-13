class Contentmanager::FrontController < Contentmanager::ContentmanagerSiteController

  hobo_controller

  def index
    @webpagesarray = childrenarray(webpages: Webpage.roots).to_json
  end

protected

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