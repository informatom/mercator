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
end