class Admin::ValuesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def index
    values = Value.includes(:property).includes(:product).includes(:property_group)
    if params[:sort]
      values = values.order(params[:sort]["0"][:field] || :title_de => params[:sort]["0"][:direction].downcase.to_sym)
    end
    if params[:search]
        values = values.where("#{params[:search]["0"][:field]} LIKE '%#{params[:search]["0"][:value]}%'")
    end
    total = values.count
    values = values.limit(params[:limit] || 100)
                   .offset(params[:offset] || 0)

    respond_to do |format|
      format.html { respond_with [] }
      format.json {
        render json: {
          status: "success",
          total: total,
          records: values.collect {
            |value| {
              recid:          value.id,
              product_number: value.product.number,
              property:       value.property.name_de,
              property_group: value.property_group.name_de,
              title_de:       value.title_de,
              title_en:       value.title_en,
              amount:         value.amount,
              unit_de:        value.unit_de,
              unit_en:        value.unit_en,
              flag:           value.flag,
              created_at:     I18n.l(value.created_at),
              updated_at:     I18n.l(value.updated_at),
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