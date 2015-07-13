class Admin::ContractsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def update
    hobo_update(redirect: contracting_contracts_path) do
      session[:selected_contract_id] = this.id
    end
  end

  def create
    hobo_create(redirect: contracting_contracts_path) do
      session[:selected_contract_id] = this.id
    end
  end

  def destroy
    @contract = Contract.find(params[:id])
    if @contract.contractitems.any?
      render :text => I18n.t("js.con.cannot_delete_contract"),
             :status => 403 and return
    end

    hobo_destroy do
      session[:selected_contract_id] = nil
      render nothing: true if request.xhr?
    end
  end
end