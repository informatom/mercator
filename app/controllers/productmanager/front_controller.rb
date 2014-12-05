class Productmanager::FrontController < Productmanager::ProductmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js, :text

  def index
    if request_param(:product_id)
      @selected_product = Product.find(request_param(:product_id))
      @selected_category = @selected_product.categories.first
    end
  end

  def show_categorytree
    render json: childrenarray(objects: Category.arrange(order: :position),
                               name_method: :name_with_status).to_json
  end

  def manage_products
    if params[:cmd] == "save-records"
      params[:changes].each do |key, change|
        product = Product.find(change[:recid])
        product.state = change[:state][:id]

        unless product.save
          render json: { status: "error", message: product.errors.first } and return
        end
      end
    end

    category = Category.find(params[:id])
    products = category.products

    render json: {
      status: "success",
      total: products.count,
      records: products.collect {
        |product| {
          recid: product.id,
          number: product.number,
          title_de: product.title_de,
          title_en: product.title_en,
          description_de: product.description_de,
          description_en: product.description_en,
          long_description_de: ActionController::Base.helpers.strip_tags(product.long_description_de),
          long_description_en: ActionController::Base.helpers.strip_tags(product.long_description_en),
          warranty_de: product.warranty_de,
          warranty_en: product.warranty_en,
          state: [I18n.t('mercator.states.' + product.state)],
          novelty: product.novelty,
          topseller: product.topseller,
          created_at: product.created_at.utc.to_i*1000,
          updated_at: product.updated_at.utc.to_i*1000
        }
      }
    }
  end

  def manage_category
    if params[:recid] == "0"
      category = Category.new
    else
      category = Category.find(params[:id])
    end

    if params[:cmd] == "save-record"
      attrs = params[:record]
      category.name_de             = attrs[:name_de]
      category.name_en             = attrs[:name_en]
      category.description_de      = attrs[:description_de]
      category.description_en      = attrs[:description_en]
      category.long_description_de = attrs[:long_description_de]
      category.long_description_en = attrs[:long_description_en]
      category.state               = attrs[:state][:id]
      category.filtermin           = attrs[:filtermin]
      category.filtermax           = attrs[:filtermax]
      category.position            = attrs[:positon].to_i
      category.parent_id           = attrs[:parent_id]
      success = category.save
    end

    if success == false
      render json: { status: "error",
                     message: category.errors.first }
    else
      render json: {
        status: "success",
        record: {
          recid:               category.id,
          name_de:             category.name_de,
          name_en:             category.name_en,
          description_de:      category.description_de,
          description_en:      category.description_en,
          long_description_de: category.long_description_de,
          long_description_en: category.long_description_en,
          position:            category.position,
          state:               {id: category.state},
          filters:             category.filters.to_s,
          filtermin:           category.filtermin,
          filtermax:           category.filtermax,
          created_at:          I18n.l(category.created_at),
          updated_at:          I18n.l(category.updated_at),
          parent_name:         (category.parent.name if category.parent),
          parent_id:           (category.parent.id   if category.parent)
        }
      }
    end
  end

  def update_categories
    reorder_categories(categories: params[:categories], parent_id: nil)
    render nothing: true
  end

  def delete_category
    if params[:id] != "0"
      category = Category.find(params[:id])
    else
      render :text => I18n.t("mercator.product_manager.cannot_delete_category.no_category_selected"),
             :status => 403 and return
    end

    if category.children.any?
      render :text => I18n.t("mercator.product_manager.cannot_delete_category.children"),
             :status => 403 and return
    end
    if category.products.any?
      render :text => I18n.t("mercator.product_manager.cannot_delete_category.products"),
             :status => 403 and return
    end

    if category.delete
      render nothing: true
    else
      render json: category.errors.first
    end
  end

  def update_categorization
    categorization = Categorization.where(product_id:  params[:product_id],
                                          category_id: params[:old_category_id])
                                   .first
    if categorization.update(category_id: params[:new_category_id])
      category_name =  Category.find(params[:new_category_id]).name
      render text: category_name
    else
      render text: categorization.errors.first, :status => 403
    end
  end

protected

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

  def reorder_categories(categories: nil,
                         parent_id: nil,
                         categorieshash: Category.all.to_a.each_with_object({}) { |category, hash| hash[category.id] = category })

    categories.each do |position, categories|
      category = categorieshash[categories["key"].to_i]
      if category.position != position.to_i || category.parent_id != parent_id
        category.update(position: position,
                        parent_id: parent_id)
      end
      if categories["children"]
        reorder_categories(categories: categories["children"],
                           parent_id: category.id,
                           categorieshash: categorieshash)
      end
    end
  end
end