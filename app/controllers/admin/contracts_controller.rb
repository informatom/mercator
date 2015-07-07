class Admin::ContractsController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def update
    hobo_update(redirect: contracting_contracts_path)
  end

  def create
    hobo_create(redirect: contracting_contracts_path)
  end

  def destroy
    hobo_destroy do
      render nothing: true if request.xhr?
    end
  end
end