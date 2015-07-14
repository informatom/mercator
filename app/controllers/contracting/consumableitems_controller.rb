class Contracting::ConsumableitemsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :index
  respond_to :html, :json

  def index
    @consumableitems = Consumableitem.where(contractitem_id: params[:contractitem_id])

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


  def manage
    if params[:recid] == "0"
      @consumableitem = Consumableitem.new
    else
      @consumableitem = Consumableitem.find(params[:recid])
    end

    if params[:cmd] == "save-record"
      attrs = params[:record]

      @consumableitem.position        = attrs[:position]
      @consumableitem.contract_type   = attrs[:contract_type]
      @consumableitem.product_number  = attrs[:product_number]
      @consumableitem.product_line    = attrs[:product_line]
      @consumableitem.description_de  = attrs[:description_de]
      @consumableitem.description_en  = attrs[:description_en]
      @consumableitem.amount          = attrs[:amount]
      @consumableitem.wholesale_price = attrs[:wholesale_price]
      @consumableitem.term            = attrs[:term]
      @consumableitem.balance6        = attrs[:balance6]
      @consumableitem.consumption1    = attrs[:consumption1]
      @consumableitem.consumption2    = attrs[:consumption2]
      @consumableitem.consumption3    = attrs[:consumption3]
      @consumableitem.consumption4    = attrs[:consumption4]
      @consumableitem.consumption5    = attrs[:consumption5]
      @consumableitem.consumption6    = attrs[:consumption6]
      @consumableitem.contractitem_id = attrs[:contractitem_id]

      success = @consumableitem.save
    end

    if success == false
      render json: { status: "error",
                     message: @consumableitem.errors.first }
    else
      render json: {
        status: "success",
        record: {
          position:        @consumableitem.position,
          contract_type:   @consumableitem.contract_type,
          product_number:  @consumableitem.product_number,
          product_line:    @consumableitem.product_line,
          description_de:  @consumableitem.description_de,
          description_en:  @consumableitem.description_en,
          amount:          @consumableitem.amount,
          wholesale_price: @consumableitem.wholesale_price,
          term:            @consumableitem.term,
          balance6:        @consumableitem.balance6,
          consumption1:    @consumableitem.consumption1,
          consumption2:    @consumableitem.consumption2,
          consumption3:    @consumableitem.consumption3,
          consumption4:    @consumableitem.consumption4,
          consumption5:    @consumableitem.consumption5,
          consumption6:    @consumableitem.consumption6,
          contractitem_id: @consumableitem.contractitem_id
        }
      }
    end
  end


  def delete
    @consumableitem = Consumableitem.find(params[:id])
    if @consumableitem.consumption1 + @consumableitem.consumption2 + @consumableitem.consumption3 +
       @consumableitem.consumption4 + @consumableitem.consumption5 + @consumableitem.consumption6 > 0
      render :text => I18n.t("js.con.cannot_delete_consumableitem"),
             :status => 403 and return
    end

    if @consumableitem.destroy
      render nothing: true
    else
      render json: @consumableitem.errors.first
    end
  end


  show_action :defaults do
    @contractitem = Contractitem.find(params[:id])
    @toner = @contractitem.toner
    if @toner
      render json: { vendor_number:   @toner.vendor_number,
                     wholesale_price: @toner.price }
    else
      render :text => I18n.t("js.con.no_toner"),
             :status => 403 and return
    end
  end
end