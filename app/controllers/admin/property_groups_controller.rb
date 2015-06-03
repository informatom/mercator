class Admin::PropertyGroupsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all
  autocomplete :name


  def index
    @property_groups = PropertyGroup.all

    respond_to do |format|
      format.html { respond_with [] }
      format.json {
        render json: {
          status: "success",
          total: @property_groups.count,
          records: @property_groups.collect {
            |property_group| {
              recid:      property_group.id,
              name_de:    property_group.name_de,
              name_en:    property_group.name_en,
              position:   property_group.position,
              created_at: I18n.l(property_group.created_at),
              updated_at: I18n.l(property_group.updated_at),
            }
          }
        }
      }
    end
  end


  def destroy
    begin
      @property_group = PropertyGroup.find(params[:id])
    rescue
      render :text => I18n.t("mercator.product_manager.cannot_delete_property_group.record_not_found"),
             :status => 403 and return
    end

    if @property_group.values.any?
      render :text => I18n.t("mercator.product_manager.cannot_delete_property_group.values"),
             :status => 403 and return
    end

    hobo_destroy do
      render nothing: true if request.xhr?
    end
  end


  def new
    if request_param(:product_id)
      @cancelpath = productmanager_property_manager_path(request_param(:product_id).to_i)
    end
    hobo_new
  end


  def create
    if product_id = page_path_param(:product_id).try(:to_i)
      session[:seleted_value] = page_path_param(:value_id).to_i
      hobo_create(redirect: productmanager_property_manager_path(product_id))
    else
      hobo_create
    end
  end


  def edit
    if request_param(:product_id)
      @cancelpath = productmanager_property_manager_path(request_param(:product_id).to_i)
    end
    hobo_edit
  end


  def update
    if product_id = page_path_param(:product_id).try(:to_i)
      session[:seleted_value] = page_path_param(:value_id).to_i
      hobo_update(redirect: productmanager_property_manager_path(product_id))
    else
      hobo_update
    end
  end
end