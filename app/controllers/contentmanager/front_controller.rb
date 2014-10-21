class Contentmanager::FrontController < Contentmanager::ContentmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js

  def index; end

  def show_foldertree
    render json: childrenarray(objects: Folder.arrange(order: :position),
                               name_method: :name,
                               folder: true).to_json
  end

  def show_webpagestree
    render json: childrenarray(objects: Webpage.arrange(order: :position),
                               name_method: :title).to_json
  end

  def update_webpages
    reorder_webpages(webpages: params[:webpages], parent_id: nil)
    render nothing: true
  end

  def show_webpage
    webpage = Webpage.find(params[:id])

    render json: { status: "success",
                   total: 6,
                   records: [{ recid: 1, attribute: "title_de", value: webpage.title_de },
                             { recid: 2, attribute: "title_en", value: webpage.title_en },
                             { recid: 3, attribute: "url",      value: webpage.url },
                             { recid: 4, attribute: "slug",     value: webpage.slug },
                             { recid: 5, attribute: "menu",     value: webpage.menu },
                             { recid: 6, attribute: "template", value: webpage.page_template.name } ] }
  end

  def show_assignments
    webpage = Webpage.find(params[:id])

    webpage.add_missing_page_content_element_assignments
    webpage.reload

    assignments = webpage.page_content_element_assignments
    render json: { status: "success",
                   total: assignments.count,
                   records: assignments.collect { |assignment| { recid: assignment.id,
                                                                 used_as: assignment.used_as,
                                                                 content_element_name: assignment.content_element.try(:name) } }
                 }
  end

  def update_folders
    reorder_folders(folders: params[:folders], parent_id: nil)
    render nothing: true
  end

  def show_content_elements
    @content_elements = ContentElement.where(folder_id: params[:id])
    @serialized_content_elements = ActiveModel::ArraySerializer.new(@content_elements).as_json
    render json: { status: "success", total: @content_elements.count, records: @serialized_content_elements }
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

  def folder
    folder = params[:recid] == "0" ? NullObject.new() : Folder.find(params[:recid])

    if params[:cmd] == "save-record"
      if params[:recid] == "0"
        folder = Folder.create(name: params[:record][:name], position: 9999)
      else
        folder.update(name: params[:record][:name])
      end
    end

    render json: { status: "success", record: { recid: folder.id, name: folder.name} }
  end

  def delete_folder
    @folder = Folder.find(params[:id])
    if @folder.content_elements.any?
      render :text => I18n.t("mercator.contentmanager.cannot_delete_folder.content_elements"),
             :status => 403 and return
    elsif @folder.children.any?
      render :text => I18n.t("mercator.contentmanager.cannot_delete_folder.subfolders"),
      :status => 403 and return
    else
      @folder.delete
      render nothing: true
    end
  end

  def content_element
    content_element = (params[:recid] == "0") ? NullObject.new() : ContentElement.find(params[:recid])

    # if params[:cmd] == "save-record"
    #   if params[:recid] == "0"
    #     content_element = ContentElement.create(params[:record].except("recid"))
    #   else
    #     params[:record][:photo] = params[:record][:photo]["0"][:content] if params[:record][:photo]["0"]
    #     params[:record][:document] = params[:record][:document]["0"][:content] if params[:record][:document]["0"]
    #     content_element.update_attributes(params[:record].except("recid"))
    #   end
    # end

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
        childhash["children"] = childrenarray(objects: children, name_method: name_method, folder: folder)
      end
      childrenarray << childhash
    end
    return childrenarray
  end
end