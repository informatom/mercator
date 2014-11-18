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
    begin
      @property = Property.find(params[:id])
    rescue
      render :text => I18n.t("mercator.product_manager.cannot_delete_property.record_not_found"),
             :status => 403 and return
    end

    if @property.values.any?
      render :text => I18n.t("mercator.product_manager.cannot_delete_property.values"),
             :status => 403 and return
    end

    hobo_destroy do
      render nothing: true if request.xhr?
    end
  end

  def create
    query = URI::parse(params[:page_path]).query

    if query
      query_params = CGI.parse(query)
      product_id = query_params["product_id"][0]
      session[:seleted_value] = query_params["value_id"][0].to_i
      hobo_create(redirect: productmanager_property_manager_path(product_id))
    else
      hobo_create
    end
  end

  def update
    query = URI::parse(params[:page_path]).query

    if query
      query_params = CGI.parse(query)
      product_id = query_params["product_id"][0]
      session[:seleted_value] = query_params["value_id"][0].to_i
      hobo_update(redirect: productmanager_property_manager_path(product_id))
    else
      hobo_create
    end
  end
end