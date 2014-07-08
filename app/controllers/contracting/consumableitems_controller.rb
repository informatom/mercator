class Contracting::ConsumableitemsController < Contracting::ContractingSiteController
#  hobo_model_controller
#  auto_actions :all

  respond_to :json

  def index
    respond_with Consumableitem.all
  end

  def show
    respond_with Consumableitem.find(params[:id])
  end

  def create
    respond_with Consumableitem.create(params[:consumableitem])
  end

  def update
    Consumableitem.find(params[:id]).update_attributes(params[:consumableitem])
    render json: Consumableitem.find(params[:id])
  end

  def destroy
    respond_with Consumableitem.find(params[:id]).delete
  end
end