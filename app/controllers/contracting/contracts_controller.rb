class Contracting::ContractsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :index
  respond_to :html, :json

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
              recid:           contract.id,
              customer:        (contract.customer.name if contract.customer),
              term:            contract.term,
              contractnumber:  contract.contractnumber,
              monitoring_rate: contract.monitoring_rate,
              startdate:       contract.startdate,
              enddate:         contract.enddate,
              created_at:      contract.created_at.utc.to_i*1000,
              updated_at:      contract.updated_at.utc.to_i*1000
            }
          }
        }
      }
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
      @contract.customer_id     = attrs[:customer_id]

      @contract.contractnumber  = attrs[:contractnumber]
      @contract.monitoring_rate = attrs[:monitoring_rate]
      @contract.term            = attrs[:term]
      @contract.startdate       = attrs[:startdate]

      success = @contract.save
    end

    if success == false
      render json: { status: "error",
                     message: @contract.errors.first }
    else
      render json: {
        status: "success",
        record: {
          recid:           @contract.id,
          customer:        (@contract.customer.email_address if @contract.customer),
          customer_id:     @contract.customer_id,
          contractnumber:  @contract.contractnumber,
          monitoring_rate: @contract.monitoring_rate,
          term:            @contract.term,
          startdate:       I18n.l(@contract.startdate)
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
      total: 13,
      records: ([ { title: "=== Tatsächliche Raten ===",
                    year1: nil, year2: nil, year3: nil, year4: nil, year5: nil, }
      ] + @contract.actual_rate_array[1..12])
    }
  end
end