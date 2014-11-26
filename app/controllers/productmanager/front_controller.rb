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

  def show_products
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
          state: I18n.t('mercator.states.' + product.state),
          novelty: product.novelty,
          topseller: product.topseller,
          created_at: product.created_at.utc.to_i*1000,
          updated_at: product.updated_at.utc.to_i*1000
        }
      }
    }
  end

  def manage_category
    category = Category.find(params[:id])

    render json: {
      status: "success",
      record: {
        name_de:             category.name_de,
        name_en:             category.name_en,
        description_de:      category.description_de,
        description_en:      category.description_en,
        long_description_de: category.long_description_de,
        long_description_en: category.long_description_en,
        position:            category.position,
        filters:             category.filters.to_s,
        filtermin:           category.filtermin,
        filtermax:           category.filtermax,
        created_at:          I18n.l(category.created_at),
        updated_at:          I18n.l(category.updated_at)
      }
    }
  end

  def update_categories
    reorder_categories(categories: params[:categories], parent_id: nil)
    render nothing: true
  end

  def delete_category
    if params[:id] != "0"
      category = Category.find(params[:id])
    else
      # Continue here with translation !!
      render :text => I18n.t("mercator.product.cannot_delete_inventory.no_category_selected"),
             :status => 403 and return
    end


    if category.children.any?
      # Continue here with translation !!
      render :text => I18n.t("mercator.product.cannot_delete_inventory.chidlren"),
             :status => 403 and return
    end
    if category.products.any?
      # Continue here with translation !!
      render :text => I18n.t("mercator.product.cannot_delete_inventory.products"),
             :status => 403 and return
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

  def reorder_categories(categories: nil, parent_id: nil)
    categories.each do |position, categories|
      category = Category.find(categories["key"])
      if category.position != position.to_i || category.parent_id != parent_id
        category.update(position: position,
                        parent_id: parent_id)
      end
      if categories["children"]
        reorder_categories(categories: categories["children"],
                           parent_id: category.id)
      end
    end
  end
end