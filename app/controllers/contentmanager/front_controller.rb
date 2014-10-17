class Contentmanager::FrontController < Contentmanager::ContentmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js

  def index
    @webpagesarray = childrenarray(objects: Webpage.arrange(order: :position), name_method: :title).to_json
  end

  def show_foldertree
    render json: childrenarray(objects: Folder.arrange(order: :position), name_method: :name, folder: true).to_json
  end

  def update_webpages
    reorder_webpages(webpages: params[:webpages], parent_id: nil)
    if request.xhr?
      hobo_ajax_response
    end
  end

  def show_webpage
    webpage = Webpage.find(params[:id])

    render json: { status: "success",
                   total: 6,
                   records: [{ recid: 1, attribute: "Titel DE", value: webpage.title_de },
                             { recid: 2, attribute: "Titel EN", value: webpage.title_en },
                             { recid: 3, attribute: "URL", value: webpage.url },
                             { recid: 4, attribute: "Slug", value: webpage.slug },
                             { recid: 5, attribute: "Menü", value: webpage.menu },
                             { recid: 6, attribute: "Template", value: webpage.page_template.name } ] }
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
    if request.xhr?
      hobo_ajax_response
    end
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
  end

  def update_page_content_element_assignment
    @page_content_element_assignment = PageContentElementAssignment.find(params[:id])
    @page_content_element_assignment.update(content_element_id: params[:content_element_id])
  end

  def folder
    folder = Folder.find(params[:recid])

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
      render :text => 'Verzeichnis kann nicht gelöscht werden: Es enthält Bausteine!', :status => 403 and return
    elsif @folder.children.any?
      render :text =>  'Verzeichnis kann nicht gelöscht werden: Es gibt Unterverzeichnisse!', :status => 403 and return
    else
      @folder.delete
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