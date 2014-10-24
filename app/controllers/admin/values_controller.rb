class Admin::ValuesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def index
    values = Value.all

    respond_to do |format|
      format.html { respond_with [] }
      format.json {
        render json: {
          status: "success",
          total: values.count,
          records: values.collect {
            |value| {
              recid:      value.id,
              title_de:   value.title_de,
              amount:     value.amount,
              unit_de:    value.unit_de,
              unit_en:    value.unit_en,
              flag:       value.flag,
              created_at: I18n.l(value.created_at),
              updated_at: I18n.l(value.updated_at),
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