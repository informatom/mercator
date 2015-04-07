class Contentmanager::FrontController < Contentmanager::ContentmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js

  def index
  end

  def show_foldertree
    render json: childrenarray(objects: Folder.arrange(order: :position),
                               name_method: :name,
                               folder: true).to_json
  end

  def show_webpagestree
    render json: childrenarray(objects: Webpage.arrange(order: :position),
                               name_method: :title_with_status).to_json
  end

  def update_webpages
    reorder_webpages(webpages: params[:webpages], parent_id: nil)
    render nothing: true
  end

  def manage_webpage
    if params[:recid] == "0"
      webpage = Webpage.new
    else
      webpage = Webpage.find(params[:id])
      session[:selected_webpage_id] = webpage.id
    end

    if params[:cmd] == "save-record"
      attrs = params[:record]
      webpage.parent_id        = attrs[:parent_id] if attrs[:parent_id]
      webpage.position         = attrs[:position]
      webpage.title_de         = attrs[:title_de]
      webpage.title_en         = attrs[:title_en]
      webpage.url              = attrs[:url]
      webpage.slug             = attrs[:slug]
      webpage.seo_description  = attrs[:seo_description]
      webpage.page_template_id = attrs[:page_template_id][:id]
      success = webpage.save
    end

    if success == false
      render json: { status: "error",
                     message: webpage.errors.first }
    else
      render json: {
        status: "success",
        record: {
          recid:            webpage.id,
          title_de:         webpage.title_de,
          title_en:         webpage.title_en,
          url:              webpage.url,
          slug:             webpage.slug,
          seo_description:  webpage.seo_description,
          position:         webpage.position,
          page_template_id: {id: webpage.page_template_id}
        }
      }
    end
  end

  def show_assignments
    webpage = Webpage.find(params[:id])

    webpage.add_missing_page_content_element_assignments
    webpage.delete_orphaned_page_content_element_assignments
    webpage.reload

    assignments = webpage.page_content_element_assignments
    render json: {
      status: "success",
      total: assignments.count,
      records: assignments.collect {
        |assignment| {
          recid: assignment.id,
          used_as: assignment.used_as,
          content_element_name: assignment.content_element.try(:name)
        }
      }
    }
  end

  def update_folders
    reorder_folders(folders: params[:folders], parent_id: nil)
    render nothing: true
  end

  def show_content_elements
    @content_elements = ContentElement.where(folder_id: params[:id])
    @serialized_content_elements = ActiveModel::ArraySerializer.new(@content_elements).as_json
    render json: {
      status: "success",
      total: @content_elements.count,
      records: @serialized_content_elements
    }
  end

  def update_content_element
    content_element = ContentElement.find(params[:id])
    @old_folder_id = content_element.folder_id
    content_element.update(folder_id: params[:folder_id])
    render text: @old_folder_id
  end

  def update_page_content_element_assignment
    page_content_element_assignment = PageContentElementAssignment.find(params[:id])
    page_content_element_assignment.update(content_element_id: params[:content_element_id])
    render text: page_content_element_assignment.webpage_id
  end

  def content_element
    content_element = (params[:recid] == "0") ? NullObject.new() : ContentElement.find(params[:recid])

    render json: {
      status: "success",
      record: {
        recid:      content_element.id,
        name_de:    content_element.name_de,
        name_en:    content_element.name_en,
        markup:     content_element.markup,
        content_de: content_element.content_de,
        content_en: content_element.content_en,
        photo:      content_element.photo_file_name,
        document:   content_element.photo_file_name
      }
    }
  end

  def get_thumbnails
    @content_elements = ContentElement.where(folder_id: params[:id]).where.not(photo_file_name: nil)
    session[:selected_folder_id] = params[:id].to_i
  end

  def set_seleted_content_element
    session[:selected_content_element_id] = params[:id].to_i
    render json: { status: "success" }
  end

  def delete_assignment
    page_content_element_assignment = PageContentElementAssignment.find(params[:id])

    if page_content_element_assignment.update(content_element_id: nil)
      render text: page_content_element_assignment.webpage_id
    else
      render json: page_content_element_assignment.errors.first
    end
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
        folder.update(position: position,
                      parent_id: parent_id)
      end
      if folders["children"]
        reorder_folders(folders: folders["children"],
                        parent_id: folder.id)
      end
    end
  end

  def childrenarray(objects: nil, name_method: nil, folder: false)
    childrenarray = []
    objects.each do |object, children|
      childhash = Hash["title"  => object.send(name_method), "key" => object.id, "folder" => folder]
      if children.any?
        childhash["children"] = childrenarray(objects: children,
                                              name_method: name_method,
                                              folder: folder)
      end
      childrenarray << childhash
    end
    return childrenarray
  end
end