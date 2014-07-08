class Contracting::ContractitemsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :all

  respond_to :json

  def index
    respond_with Contractitem.all
  end

  def show
    respond_with Contractitem.find(params[:id])
  end

  def create
    respond_with Contractitem.create(params[:contractitem])
  end

  def update
    Contractitem.find(params[:id]).update_attributes(params[:contractitem])
    render json: Contractitem.find(params[:id])
  end

  def destroy
    respond_with Contractitem.find(params[:id]).delete
  end
end