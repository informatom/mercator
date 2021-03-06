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
              product_number:  (contractitem.product.number if contractitem.product),
              product_title:   contractitem.product_title,
              amount:          contractitem.amount,
              volume:          contractitem.volume,
              vat:             contractitem.vat,
              startdate:       contractitem.startdate,
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
      @contractitem.position        = attrs[:position]
      @contractitem.startdate       = attrs[:startdate].to_date.change(day: 1)
      @contractitem.product_number  = attrs[:product_number]
      @contractitem.product_id      = attrs[:product_id]
      @contractitem.product_title   = attrs[:product_title]
      @contractitem.amount          = attrs[:amount]
      @contractitem.marge           = attrs[:marge]
      @contractitem.monitoring_rate     = attrs[:monitoring_rate]
      @contractitem.volume_bw       = attrs[:volume_bw]
      @contractitem.volume_color    = attrs[:volume_color]
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
          startdate:       I18n.l(@contractitem.startdate),
          product_number:  @contractitem.product_number,
          product_title:   @contractitem.product_title,
          product_id:      @contractitem.product_id,
          amount:          @contractitem.amount,
          marge:           @contractitem.marge,
          volume_bw:       @contractitem.volume_bw,
          volume_color:    @contractitem.volume_color,
          vat:             @contractitem.vat,
          monitoring_rate: @contractitem.monitoring_rate,
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
      total: 21,
      records: ([
        {
          title: "Jahresbeginn",
          year1: l(@contractitem.contract.startdate),
          year2: l(@contractitem.contract.startdate + 1.year),
          year3: l(@contractitem.contract.startdate + 2.year),
          year4: l(@contractitem.contract.startdate + 3.year),
          year5: l(@contractitem.contract.startdate + 4.year),
        }, {
          title: "Jahresende",
          year1: l(@contractitem.contract.startdate + 1.year - 1.day),
          year2: l(@contractitem.contract.startdate + 2.year - 1.day),
          year3: l(@contractitem.contract.startdate + 3.year - 1.day),
          year4: l(@contractitem.contract.startdate + 4.year - 1.day),
          year5: l(@contractitem.contract.startdate + 5.year - 1.day),
        }, {
          title: "Rate (EUR)",
          year1: number_to_currency(@contractitem.monthly_rate(1)),
          year2: number_to_currency(@contractitem.monthly_rate(2)),
          year3: number_to_currency(@contractitem.monthly_rate(3)),
          year4: number_to_currency(@contractitem.monthly_rate(4)),
          year5: number_to_currency(@contractitem.monthly_rate(5)),
        }, {
          title: "Monate ohne Rate",
          year1: '---',
          year2: @contractitem.months_without_rates(1),
          year3: @contractitem.months_without_rates(2),
          year4: @contractitem.months_without_rates(3),
          year5: @contractitem.months_without_rates(4),
        }, {
          title: "Rate im Folgemonat (EUR)",
          year1: '---',
          year2: number_to_currency(@contractitem.next_month(1)),
          year3: number_to_currency(@contractitem.next_month(2)),
          year4: number_to_currency(@contractitem.next_month(3)),
          year5: number_to_currency(@contractitem.next_month(4)),
        }, {
          title: "Summe Gutschrift/Nachzahlung",
          year1: '---',
          year2: number_to_currency(@contractitem.balance(1)),
          year3: number_to_currency(@contractitem.balance(2)),
          year4: number_to_currency(@contractitem.balance(3)),
          year5: number_to_currency(@contractitem.balance(4)),
          payoff: number_to_currency(@contractitem.balance(5)),
        }, {
          title: "Ausgaben",
          year1: number_to_currency(@contractitem.expenses(1)),
          year2: number_to_currency(@contractitem.expenses(2)),
          year3: number_to_currency(@contractitem.expenses(3)),
          year4: number_to_currency(@contractitem.expenses(4)),
          year5: number_to_currency(@contractitem.expenses(5)),
        }, {
          title: "Deckungsbeitrag",
          year1: number_to_currency(@contractitem.profit(1)),
          year2: number_to_currency(@contractitem.profit(2)),
          year3: number_to_currency(@contractitem.profit(3)),
          year4: number_to_currency(@contractitem.profit(4)),
          year5: number_to_currency(@contractitem.profit(5)),
        }, { title: "=== Tatsächliche Raten ===",
             year1: nil, year2: nil, year3: nil, year4: nil, year5: nil, }
      ] + @contractitem.actual_rate_array[1..12])
    }
  end

  show_action :upload

  show_action :do_upload, method: :post do
    @contractitem = Contractitem.find(params[:id])

    @sheet = Roo::Spreadsheet.open(params[:xlsx].path, extension: :xlsx)

    @sheet.each_with_index do |row, index|
      next if index < 2
      next unless (@contractitem.product_number[3..-1] == row[8])
      next if (row[8] == row[11])

      price = Toner.find_by(article_number: row[11]).try(:price) || 0

      Consumableitem.create(contractitem_id: @contractitem.id,
                            position: index,
                            product_number: row[11],
                            product_title: row[16],
                            theyield: row[30],
                            amount: row[28],
                            contract_type: "Haupt",
                            wholesale_price1: price,
                            wholesale_price2: 0,
                            wholesale_price3: 0,
                            wholesale_price4: 0,
                            wholesale_price5: 0)
    end

    redirect_to contracting_consumableitems_path(contractitem_id: params[:id])
  end
end