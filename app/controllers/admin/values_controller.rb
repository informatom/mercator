class Admin::ValuesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def index
    values = Value
    if params[:sort] # sorting is requested
      values = values.order(params[:sort]["0"][:field] || :title_de => params[:sort]["0"][:direction].downcase.to_sym)
    end
    if params[:search]
      params[:search].each do |key, value|
        values = values.offset(params[:offset] || 0)
                       .where("#{value[:field]} LIKE '#{value[:value]}%'")
      end
    end
    total = values.count
    values = values.limit(params[:limit] || 100)

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