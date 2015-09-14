class Contracting::ConsumableitemsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :index
  respond_to :html, :json

  def index
    @consumableitems = Consumableitem.where(contractitem_id: params[:contractitem_id]).order(:position)
    if params[:contractitem_id]
      session[:selected_contract_id] = Contractitem.find(params[:contractitem_id]).contract_id
    end

    respond_to do |format|
      format.html
      format.text {
        render json: {
          status: "success",
          total: @consumableitems.count,
          records: @consumableitems.collect {
            |consumableitem| {
              recid:            consumableitem.id,
              position:         consumableitem.position,
              contract_type:    consumableitem.contract_type,
              product_number:   consumableitem.product_number,
              product_title:    consumableitem.product_title,
              product_line:     consumableitem.product_line,
              amount:           consumableitem.amount,
              theyield:         consumableitem.theyield,
              wholesale_price1: consumableitem.wholesale_price1,
              wholesale_price2: consumableitem.wholesale_price2,
              wholesale_price3: consumableitem.wholesale_price3,
              wholesale_price4: consumableitem.wholesale_price4,
              wholesale_price5: consumableitem.wholesale_price5,
              price:            consumableitem.price(1),
              value:            consumableitem.value(1),
              monthly_rate:     consumableitem.monthly_rate(1),
              term:             consumableitem.term,
              consumption1:     consumableitem.consumption1,
              consumption2:     consumableitem.consumption2,
              consumption3:     consumableitem.consumption3,
              consumption4:     consumableitem.consumption4,
              consumption5:     consumableitem.consumption5,
              new_rate2:        consumableitem.new_rate(2),
              new_rate3:        consumableitem.new_rate(3),
              new_rate4:        consumableitem.new_rate(4),
              new_rate5:        consumableitem.new_rate(5),
              balance1:         consumableitem.balance(1),
              balance2:         consumableitem.balance(2),
              balance3:         consumableitem.balance(3),
              balance4:         consumableitem.balance(4),
              balance5:         consumableitem.balance(5),
              created_at:       consumableitem.created_at,
              updated_at:       consumableitem.updated_at
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

      @consumableitem.position         = attrs[:position]
      @consumableitem.contract_type    = attrs[:contract_type]
      @consumableitem.product_number   = attrs[:product_number]
      @consumableitem.product_title    = attrs[:product_title]
      @consumableitem.product_line     = attrs[:product_line]
      @consumableitem.amount           = attrs[:amount]
      @consumableitem.theyield         = attrs[:theyield]
      @consumableitem.wholesale_price1 = attrs[:wholesale_price1]
      @consumableitem.wholesale_price2 = attrs[:wholesale_price2]
      @consumableitem.wholesale_price3 = attrs[:wholesale_price3]
      @consumableitem.wholesale_price4 = attrs[:wholesale_price4]
      @consumableitem.wholesale_price5 = attrs[:wholesale_price5]
      @consumableitem.term             = attrs[:term]
      @consumableitem.consumption1     = attrs[:consumption1]
      @consumableitem.consumption2     = attrs[:consumption2]
      @consumableitem.consumption3     = attrs[:consumption3]
      @consumableitem.consumption4     = attrs[:consumption4]
      @consumableitem.consumption5     = attrs[:consumption5]
      @consumableitem.contractitem_id  = attrs[:contractitem_id]

      success = @consumableitem.save
    end

    if success == false
      render json: { status: "error",
                     message: @consumableitem.errors.first }
    else
      render json: {
        status: "success",
        record: {
          position:         @consumableitem.position,
          contract_type:    @consumableitem.contract_type,
          product_number:   @consumableitem.product_number,
          product_title:    @consumableitem.product_title,
          product_line:     @consumableitem.product_line,
          amount:           @consumableitem.amount,
          theyield:         @consumableitem.theyield,
          wholesale_price1: @consumableitem.wholesale_price1,
          wholesale_price2: @consumableitem.wholesale_price2,
          wholesale_price3: @consumableitem.wholesale_price3,
          wholesale_price4: @consumableitem.wholesale_price4,
          wholesale_price5: @consumableitem.wholesale_price5,
          term:             @consumableitem.term,
          consumption1:     @consumableitem.consumption1,
          consumption2:     @consumableitem.consumption2,
          consumption3:     @consumableitem.consumption3,
          consumption4:     @consumableitem.consumption4,
          consumption5:     @consumableitem.consumption5,
          contractitem_id:  @consumableitem.contractitem_id
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
end