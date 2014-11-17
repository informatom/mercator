class Productmanager::PropertyManagerController < Productmanager::ProductmanagerSiteController

  hobo_controller
  respond_to :html, :json, :js, :text

  def index
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

  def show_valuetree
    valuearray = []
    product = Product.find(params[:id])
    hashed_values = product.hashed_values

    hashed_values.each do | key, values |
      property_array = []
      property_group = PropertyGroup.find(key)
      property_group_hash =  Hash["title"  => property_group.name,
                                  "key" => property_group.id,
                                  "folder" => true]
      values.each do |value|
         property_array << Hash["title"  => value.property.name + ": <em style='color: orange'>" + value.display + "</em>",
                                "key" => value.id,
                                "property_id" => value.property.id,
                                "property_group_id" => value.property_group.id,
                                "folder" => false]
      end
      property_group_hash["children"] = property_array
      valuearray << property_group_hash
    end

    render json: valuearray.to_json
  end

  def manage_value
    value = Value.find(params[:id])

    if params[:cmd] == "save-record"
      attrs = params[:record]
      flag = nil
      flag = true if attrs[:flag] == "1"
      flag = false if attrs[:flag] == "0"
      
      value.state    = attrs[:state][:id]
      value.title_de = attrs[:title_de]
      value.title_en = attrs[:title_en]
      value.amount   = attrs[:amount]
      value.unit_de  = attrs[:unit_de]
      value.unit_en  = attrs[:unit_en]
      value.flag     = flag
      success = value.save
    end

    if success == false
      render json: { status: "error",
                     message: value.errors.first }
    else  
      render json: { status: "success",
                     record: {
                       recid:      value.id,
                       state:      value.state,
                       title_de:   value.title_de,
                       title_en:   value.title_en,
                       amount:     value.amount,
                       unit_de:    value.unit_de,
                       unit_en:    value.unit_en,
                       flag:       value.flag,
                       created_at: I18n.l(value.created_at),
                       updated_at: I18n.l(value.updated_at)
                     }
                   }
    end
  end

  def delete_value
    value = Value.find(params[:id])
    if value.delete
      render nothing: true
    else
      render json: value.errors.first
    end
  end
end