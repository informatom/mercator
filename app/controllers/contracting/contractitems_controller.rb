class Contracting::ContractitemsController < Contracting::ContractingSiteController
  include ActionView::Helpers::NumberHelper

  hobo_model_controller
  auto_actions :index
  respond_to :html, :text

  def index
    @contractitems = Contractitem.where(contract_id: params[:contract_id])

    respond_to do |format|
      format.html
      format.text {
        render json: {
          status: "success",
          total: @contractitems.count,
          records: @contractitems.collect {
            |contractitem| {
              recid:           contractitem.id,
              position:        contractitem.position,
              user:            (contractitem.user.email_address if contractitem.user),
              product_number:  (contractitem.product.number if contractitem.product),
              toner:           (contractitem.toner.article_number if contractitem.toner),
              description_de:  contractitem.description_de,
              description_en:  contractitem.description_en,
              amount:          contractitem.amount,
              unit:            contractitem.unit,
              volume:          contractitem.volume,
              product_price:   contractitem.product_price,
              vat:             contractitem.vat,
              value:           contractitem.value,
              discount_abs:    contractitem.discount_abs,
              term:            contractitem.term,
              startdate:       contractitem.startdate,
              enddate:         contractitem.enddate,
              volume_bw:       contractitem.volume_bw,
              volume_color:    contractitem.volume_color,
              marge:           contractitem.marge,
              monitoring_rate: contractitem.monitoring_rate,
              created_at:      contractitem.created_at.utc.to_i*1000,
              updated_at:      contractitem.updated_at.utc.to_i*1000
            }
          }
        }
      }
    end
  end


  def manage
    if params[:recid] == "0"
      @contractitem = Contractitem.new
    else
      @contractitem = Contractitem.find(params[:recid])
    end

    if params[:cmd] == "save-record"
      attrs = params[:record]

      user_id = User.find_by(email_address: attrs[:user]).try(:id)
      toner_id = Toner.find_by(article_number: attrs[:toner]).try(:id)
      product_id = Product.find_by(number: attrs[:product_number]).try(:id)

      @contractitem.position        = attrs[:position]
      @contractitem.term            = attrs[:term]
      @contractitem.user_id         = user_id
      @contractitem.startdate       = attrs[:startdate]
      @contractitem.product_id      = product_id
      @contractitem.toner_id        = toner_id
      @contractitem.description_de  = attrs[:description_de]
      @contractitem.description_en  = attrs[:description_en]
      @contractitem.amount          = attrs[:amount]
      @contractitem.unit            = attrs[:unit]
      @contractitem.marge           = attrs[:marge]
      @contractitem.volume_bw       = attrs[:volume_bw]
      @contractitem.volume_color    = attrs[:volume_color]
      @contractitem.product_price   = attrs[:product_price]
      @contractitem.monitoring_rate = attrs[:monitoring_rate]
      @contractitem.discount_abs    = attrs[:discount_abs]
      @contractitem.value           = attrs[:value]
      @contractitem.vat             = attrs[:vat]
      @contractitem.contract_id     = attrs[:contract_id]

      success = @contractitem.save
    end

    if success == false
      render json: { status: "error",
                     message: @contractitem.errors.first }
    else
      render json: {
        status: "success",
        record: {
          recid:           @contractitem.id,
          position:        @contractitem.position,
          term:            @contractitem.term,
          user:            (@contractitem.user.email_address if @contractitem.user),
          startdate:       I18n.l(@contractitem.startdate),
          product_number:  (@contractitem.product.number if @contractitem.product),
          toner:           (@contractitem.toner.article_number if @contractitem.toner),
          description_de:  @contractitem.description_de,
          description_en:  @contractitem.description_en,
          amount:          @contractitem.amount,
          unit:            @contractitem.unit,
          marge:           @contractitem.marge,
          volume_bw:       @contractitem.volume_bw,
          volume_color:    @contractitem.volume_color,
          product_price:   @contractitem.product_price,
          monitoring_rate: @contractitem.monitoring_rate,
          discount_abs:    @contractitem.discount_abs,
          value:           @contractitem.value,
          vat:             @contractitem.vat,
          created_at:      I18n.l(@contractitem.created_at),
          updated_at:      I18n.l(@contractitem.updated_at),
          contract_id:     @contractitem.contract_id
        }
      }
    end
  end


  def delete
    @contractitem = Contractitem.find(params[:id])

    if @contractitem.consumableitems.any?
      render :text => I18n.t("js.con.cannot_delete_contractitem"),
             :status => 403 and return
    end

    if @contractitem.destroy
      render nothing: true
    else
      render json: @contractitem.errors.first
    end
  end


  show_action :calendar do
    @contractitem = Contractitem.find(params[:id])

    render json: {
      status: "success",
      total: 7,
      records: [
        {
          title: "Jahresbeginn",
          year1: l(@contractitem.startdate),
          year2: l(@contractitem.startdate + 1.year),
          year3: l(@contractitem.startdate + 2.year),
          year4: l(@contractitem.startdate + 3.year),
          year5: l(@contractitem.startdate + 4.year),
          year6: l(@contractitem.startdate + 5.year)
        }, {
          title: "Jahresende",
          year1: l(@contractitem.startdate + 1.year - 1.day),
          year2: l(@contractitem.startdate + 2.year - 1.day),
          year3: l(@contractitem.startdate + 3.year - 1.day),
          year4: l(@contractitem.startdate + 4.year - 1.day),
          year5: l(@contractitem.startdate + 5.year - 1.day),
          year6: l(@contractitem.startdate + 6.year - 1.day)
        }, {
          title: "Monate ohne Rate",
          year1: @contractitem.months_without_rates(1),
          year2: @contractitem.months_without_rates(2),
          year3: @contractitem.months_without_rates(3),
          year4: @contractitem.months_without_rates(4),
          year5: @contractitem.months_without_rates(5),
          year6: '---'
        }, {
          title: "Folgeraten (EUR)",
          year1: '---',
          year2: number_to_currency(@contractitem.new_rate(2)),
          year3: number_to_currency(@contractitem.new_rate(3)),
          year4: number_to_currency(@contractitem.new_rate(4)),
          year5: number_to_currency(@contractitem.new_rate(5)),
          year6: number_to_currency(@contractitem.new_rate(6))
        }, {
          title: "Folgemonat",
          year1: @contractitem.next_month(1).round,
          year2: @contractitem.next_month(2).round,
          year3: @contractitem.next_month(3).round,
          year4: @contractitem.next_month(4).round,
          year5: @contractitem.next_month(5).round,
          year6: '---'
        }, {
          title: "Folgeraten mit Monitoring (EUR)",
          year1:'---',
          year2: number_to_currency(@contractitem.new_rate_with_monitoring(2)),
          year3: number_to_currency(@contractitem.new_rate_with_monitoring(3)),
          year4: number_to_currency(@contractitem.new_rate_with_monitoring(4)),
          year5: number_to_currency(@contractitem.new_rate_with_monitoring(5)),
          year6: number_to_currency(@contractitem.new_rate_with_monitoring(6))
        }, {
          title: "Summe Gutschrift/Nachzahlung",
          year1: number_to_currency(@contractitem.balance(1)),
          year2: number_to_currency(@contractitem.balance(2)),
          year3: number_to_currency(@contractitem.balance(3)),
          year4: number_to_currency(@contractitem.balance(4)),
          year5: number_to_currency(@contractitem.balance(5)),
          year6: number_to_currency(@contractitem.balance(6))
        }
      ]
    }
  end
end