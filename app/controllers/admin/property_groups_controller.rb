class Admin::PropertyGroupsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all
  autocomplete :name

  def index
    property_groups = PropertyGroup.all

    respond_to do |format|
      format.html { respond_with [] }
      format.json {
        render json: {
          status: "success",
          total: property_groups.count,
          records: property_groups.collect {
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
    hobo_destroy do
      render json: { status: "success" } if request.xhr?
    end
  end
end