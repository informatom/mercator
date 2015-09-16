class Contracting::ContractsController < Contracting::ContractingSiteController
  include ActionView::Helpers::NumberHelper

  hobo_model_controller
  auto_actions :index
  respond_to :html, :json, :csv

  def index
    @contracts = Contract.all

    respond_to do |format|
      format.html
      format.text {
        render json: {
          status: "success",
          total: @contracts.count,
          records: @contracts.collect {
            |contract| {
              recid:            contract.id,
              customer:         contract.customer,
              customer_account: contract.customer_account,
              contractnumber:   contract.contractnumber,
              startdate:        contract.startdate,
              enddate:          contract.enddate,
              created_at:       contract.created_at.utc.to_i*1000,
              updated_at:       contract.updated_at.utc.to_i*1000
            }
          }
        }
      }
    end
  end


  def show
    respond_to do |format|
      format.csv { render text: Contract.find(params[:id]).to_csv }
    end
  end


  def manage
    if params[:recid] == "0"
      @contract = Contract.new
    else
      @contract = Contract.find(params[:recid])
    end

    if params[:cmd] == "save-record"
      attrs = params[:record]
      @contract.customer         = attrs[:customer]
      @contract.customer_account = attrs[:customer_account]
      @contract.contractnumber   = attrs[:contractnumber]
      @contract.startdate        = attrs[:startdate].to_date.change(day: 1)

      success = @contract.save
    end

    if success == false
      render json: { status: "error",
                     message: @contract.errors.first }
    else
      render json: {
        status: "success",
        record: {
          recid:            @contract.id,
          customer:         @contract.customer,
          customer_account: @contract.customer_account,
          contractnumber:   @contract.contractnumber,
          startdate:        I18n.l(@contract.startdate)
        }
      }
    end
  end


  def delete
    @contract = Contract.find(params[:id])

    if @contract.contractitems.any?
      render :text => I18n.t("js.con.cannot_delete_contract"),
             :status => 403 and return
    end

    if @contract.destroy
      render nothing: true
    else
      render json: @contract.errors.first
    end
  end


  show_action :calendar do
    @contract = Contract.find(params[:id])

    render json: {
      status: "success",
      total: 18,
      records: ([
        {
          title: "Jahresbeginn",
          year1: l(@contract.startdate),
          year2: l(@contract.startdate + 1.year),
          year3: l(@contract.startdate + 2.year),
          year4: l(@contract.startdate + 3.year),
          year5: l(@contract.startdate + 4.year),
        }, {
          title: "Jahresende",
          year1: l(@contract.startdate + 1.year - 1.day),
          year2: l(@contract.startdate + 2.year - 1.day),
          year3: l(@contract.startdate + 3.year - 1.day),
          year4: l(@contract.startdate + 4.year - 1.day),
          year5: l(@contract.startdate + 5.year - 1.day),
        }, {
          title: "Summe Gutschrift/Nachzahlung",
          year1: '---',
          year2: number_to_currency(@contract.balance(1)),
          year3: number_to_currency(@contract.balance(2)),
          year4: number_to_currency(@contract.balance(3)),
          year5: number_to_currency(@contract.balance(4)),
          payoff: number_to_currency(@contract.balance(5)),
        }, {
          title: "Ausgaben",
          year1: number_to_currency(@contract.expenses(1)),
          year2: number_to_currency(@contract.expenses(2)),
          year3: number_to_currency(@contract.expenses(3)),
          year4: number_to_currency(@contract.expenses(4)),
          year5: number_to_currency(@contract.expenses(5)),
        }, {
          title: "Deckungsbeitrag",
          year1: number_to_currency(@contract.profit(1)),
          year2: number_to_currency(@contract.profit(2)),
          year3: number_to_currency(@contract.profit(3)),
          year4: number_to_currency(@contract.profit(4)),
          year5: number_to_currency(@contract.profit(5)),
        },{
          title: "=== Tatsächliche Raten ===",
          year1: nil, year2: nil, year3: nil, year4: nil, year5: nil,
        }
      ] + @contract.actual_rate_array[1..12])
    }
  end
end