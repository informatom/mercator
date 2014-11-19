class Productmanager::FrontController < Productmanager::ProductmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js, :text

  def index; end

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

  def show_category
    category = Category.find(params[:id])

    render json: { status: "success",
                   total: 12,
                   records: [{ recid: 1, attribute: I18n.t("attributes.name") + " DE", value: category.name_de },
                             { recid: 2, attribute: I18n.t("attributes.name") + " EN", value: category.name_en },
                             { recid: 3, attribute: I18n.t("attributes.description") + " DE", value: category.description_de },
                             { recid: 4, attribute: I18n.t("attributes.description") + " EN", value: category.description_en },
                             { recid: 5, attribute: I18n.t("attributes.long_description") + " DE", value: category.long_description_de },
                             { recid: 6, attribute: I18n.t("attributes.long_description") + " EN", value: category.long_description_en },
                             { recid: 7, attribute: I18n.t("attributes.position"), value: category.position },
                             { recid: 8, attribute: I18n.t("attributes.filters"), value: category.filters.to_s },
                             { recid: 9, attribute: I18n.t("attributes.filtermin"), value: category.filtermin },
                             { recid: 10, attribute: I18n.t("attributes.filtermax"), value: category.filtermax },
                             { recid: 11, attribute: I18n.t("attributes.created_at"), value: I18n.l(category.created_at) },
                             { recid: 12, attribute: I18n.t("attributes.updated_at"), value: I18n.l(category.updated_at) }] }
  end

  def update_categories
    reorder_categories(categories: params[:categories], parent_id: nil)
    render nothing: true
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