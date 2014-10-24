class Admin::PropertiesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def do_filter
    do_transition_action :filter do
      category = Category.find(params[:category_id])
      category.update_property_hash
      redirect_to edit_properties_admin_category_path(category)
    end
  end

  def do_dont_filter
    do_transition_action :dont_filter do
      category = Category.find(params[:category_id])
      category.update_property_hash
      redirect_to edit_properties_admin_category_path(category)
    end
  end

  def index
    property = Property.all

    respond_to do |format|
      format.html { respond_with [] }
      format.json {
        render json: {
          status: "success",
          total: property.count,
          records: property.collect {
            |property| {
              recid:     property.id,
              name_de:    property.name_de,
              name_en:    property.name_en,
              datatype:   property.datatype,
              icecat_id:  property.icecat_id,
              position:   property.position,
              created_at: I18n.l(property.created_at),
              updated_at: I18n.l(property.updated_at),
            }
          }
        }
      }
    end
  end

  def destroy
    hobo_destroy do
      render json: { status: "success" } if request.xhr?
    end
  end
end