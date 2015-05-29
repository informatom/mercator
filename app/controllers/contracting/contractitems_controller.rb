class Contracting::ContractitemsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :all
  respond_to :html, :json

  def default_serializer_options
    {root: "contractitem" }
  end

  def index
    hobo_index do |format|
      format.json { render json: this }
      format.html {}
    end
  end

  def show
    hobo_show do |format|
      format.json { render json: this }
      format.html {}
    end
  end

   def create
    hobo_create do |format|
      format.json { render json: this }
      format.html {}
    end
  end

  def update
    hobo_update do |format|
      format.json { render json: this }
      format.html {}
    end
  end

  def destroy
    hobo_destroy do |format|
      format.json { render json: {} }
      format.html {}
    end
  end
end