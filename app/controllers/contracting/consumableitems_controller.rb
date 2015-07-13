class Contracting::ConsumableitemsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :index
  respond_to :html, :json

  def index
    @consumableitems = Consumableitem.where(contractitem_id: params[:contract_id])

    respond_to do |format|
      format.html
      format.text {
        render json: {
          status: "success",
          total: @consumableitems.count,
          records: @consumableitems.collect {
            |consumableitem| {
              recid:           consumableitem.id,
              position:        consumableitem.position,
              contract_type:   consumableitem.contract_type,
              product_number:  consumableitem.product_number,
              product_line:    consumableitem.product_line,
              description_de:  consumableitem.description_de,
              description_en:  consumableitem.description_en,
              amount:          consumableitem.amount,
              theyield:        consumableitem.theyield,
              wholesale_price: consumableitem.wholesale_price,
              price:           consumableitem.price,
              value:           consumableitem.value,
              monthly_rate:    consumableitem.monthly_rate,
              term:            consumableitem.term,
              consumption1:    consumableitem.consumption1,
              consumption2:    consumableitem.consumption2,
              consumption3:    consumableitem.consumption3,
              consumption4:    consumableitem.consumption4,
              consumption5:    consumableitem.consumption5,
              consumption6:    consumableitem.consumption6,
              new_rate2:       consumableitem.new_rate(2),
              new_rate3:       consumableitem.new_rate(3),
              new_rate4:       consumableitem.new_rate(4),
              new_rate5:       consumableitem.new_rate(5),
              new_rate6:       consumableitem.new_rate(6),
              balance1:        consumableitem.balance(1),
              balance2:        consumableitem.balance(2),
              balance3:        consumableitem.balance(3),
              balance4:        consumableitem.balance(4),
              balance5:        consumableitem.balance(5),
              balance6:        consumableitem.balance6, # ! That's OK!
              created_at:      consumableitem.created_at,
              updated_at:      consumableitem.updated_at
            }
          }
        }
      }
    end
  end


  def delete
    @consumableitem = Consumableitem.find(params[:id])
    if @consumableitem.destroy
      render nothing: true
    else
      render json: @consumableitem.errors.first
    end
  end
end