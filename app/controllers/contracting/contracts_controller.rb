class Contracting::ContractsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :all

  respond_to :json

  def index
    respond_with Contract.all
  end

  def show
    respond_with Contract.find(params[:id])
  end

   def create
    respond_with Contract.create(params[:contract])
  end

  def update
    Contract.find(params[:id]).update_attributes(params[:contract])
    render json: Contract.find(params[:id])
  end

  def destroy
    respond_with Contract.find(params[:id]).delete
  end
end