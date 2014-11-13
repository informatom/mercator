class Productmanager::FrontController < Productmanager::ProductmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js, :text

  def index; end

  def show_categorytree
    render json: childrenarray(objects: Category.arrange(order: :position),
                               name_method: :name_with_status).to_json
  end

  def property_manager
    product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.text {
        render json: {
          status: "success",
          total: 13,
          records: [{
            recid: 1,
            attribute: I18n.t("attributes.number") + " DE",
            value: product.number
          }, {
            recid: 2,
            attribute: I18n.t("attributes.title") + " DE",
            value: product.title_de
          }, {
            recid: 3,
            attribute: I18n.t("attributes.title") + " EN",
            value: product.title_en
          }, {
            recid: 4,
            attribute: I18n.t("attributes.description") + " DE",
            value: product.description_en
          }, {
            recid: 5,
            attribute: I18n.t("attributes.description") + " EN",
            value: product.description_en
          }, {
            recid: 6,
            attribute: I18n.t("attributes.long_description") + " DE",
            value: ActionController::Base.helpers.strip_tags(product.long_description_de)
          }, {
            recid: 7,
            attribute: I18n.t("attributes.long_description") + " EN",
            value: ActionController::Base.helpers.strip_tags(product.long_description_en)
          }, {
            recid: 8,
            attribute: I18n.t("attributes.warranty") + " DE",
            value: product.warranty_de
          }, {
            recid: 9,
            attribute: I18n.t("attributes.warranty") + " EN",
            value: product.warranty_en
          }, {
            recid: 10,
            attribute: I18n.t("attributes.novelty"),
            value: product.novelty.to_s
          }, {
            recid: 11,
            attribute: I18n.t("attributes.topseller"),
            value: product.topseller
          }, {
            recid: 12,
            attribute: I18n.t("attributes.created_at"),
            value: I18n.l(product.created_at)
          }, {
            recid: 13,
            attribute: I18n.t("attributes.updated_at"),
            value: I18n.l(product.updated_at)
          }]
        }
      }
    end
  end

  def show_properties
    properties = Property.all

    render json: {
      status: "success",
      total: properties.count,
      records: properties.collect {
        |property| {
          recid:    property.id,
          position: property.position,
          name:     property.name
        }
      }
    }
  end

  def show_property_groups
    property_groups = PropertyGroup.all

    render json: {
      status: "success",
      total: property_groups.count,
      records: property_groups.collect {
        |property_group| {
          recid:    property_group.id,
          position: property_group.position,
          name:     property_group.name
        }
      }
    }
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

  def show_valuetree
    valuearray = []
    product = Product.find(params[:id])
    hashed_values = product.hashed_values

    hashed_values.each do | key, values |
      property_array = []
      property_group = PropertyGroup.find(key)
      property_group_hash =  Hash["title"  => property_group.name, "key" => property_group.id, "folder" => true]
      values.each do |value|
         property_array << Hash["title"  => value.property.name + ": <em style='color: orange'>" + value.display + "</em>",
                                "key" => value.id,
                                "folder" => false]
      end
      property_group_hash["children"] = property_array
      valuearray << property_group_hash
    end

    render json: valuearray.to_json
  end

protected

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