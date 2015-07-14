class Contracting::ContractsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :index
  respond_to :html, :json

  index_action :manage_contracts do
    if params[:cmd] == "save-records" && params[:changes]
      params[:changes].each do |key, change|
        contract = Contract.find(change[:recid])

        unless contract.save
          render json: { status: "error", message: contract.errors.first } and return
        end
      end
    end

    @contracts = Contract.all

    render json: {
      status: "success",
      total: @contracts.count,
      records: @contracts.collect {
        |contract| {
          recid: contract.id,
          customer: (contract.customer.name if contract.customer),
          consultant: (contract.consultant.name if contract.consultant),
          conversation: (contract.conversation.name if contract.conversation),
          term: contract.term,
          startdate: contract.startdate,
          enddate: contract.enddate,
          created_at: contract.created_at.utc.to_i*1000,
          updated_at: contract.updated_at.utc.to_i*1000
        }
      }
    }
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
      @contract.consultant_id   = attrs[:consultant_id]
      @contract.conversation_id = attrs[:conversation_id]
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
          consultant:      (@contract.consultant.email_address if @contract.consultant),
          consultant_id:   @contract.consultant_id,
          conversation:    (@contract.conversation.name if @contract.conversation),
          conversation_id: @contract.conversation_id,
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
end