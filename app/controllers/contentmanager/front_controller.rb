class Contentmanager::FrontController < Contentmanager::ContentmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js

  def index
    @webpagesarray = childrenarray(objects: Webpage.arrange, name_method: :title).to_json
    @foldersarray = childrenarray(objects: Folder.arrange, name_method: :name, folder: true).to_json
  end

  def update_webpages
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

  def update_folders
    reorder_folders(folders: params[:folders], parent_id: nil)
    if request.xhr?
      hobo_ajax_response
    end
  end

  def show_content_elements
    @content_elements = ContentElement.all
    @serialized_content_elements = ActiveModel::ArraySerializer.new(@content_elements).as_json
    render json: { status: "success", total: @content_elements.count, records: @serialized_content_elements }
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

  def reorder_folders(folders: nil, parent_id: nil)
    folders.each do |position, folders|
      folder = Folder.find(folders["key"])
      if folder.position != position.to_i || folder.parent_id != parent_id
        folder.update(position: position, parent_id: parent_id)
      end
      reorder_folders(folders: folders["children"], parent_id: folder.id) if folders["children"]
    end
  end

  def childrenarray(objects: nil, name_method: nil, folder: false)
    childrenarray = []
    objects.each do |object, children|
      childhash = Hash["title"  => object.send(name_method), "key" => object.id, "folder" => folder]
      if children.any?
        childhash["children"] = childrenarray(objects: children, name_method: name_method)
      end
      childrenarray << childhash
    end
    return childrenarray
  end
end