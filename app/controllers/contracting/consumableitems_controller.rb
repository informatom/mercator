class Contracting::ConsumableitemsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :all
  respond_to :html, :json

  def default_serializer_options
    {root: "consumableitem" }
  end

  def index
    hobo_index do |format|
      format.json { render json: this }
      format.html { hobo_index }
    end
  end

  def show
    hobo_show do |format|
      format.json { render json: this }
      format.html { hobo_show }
    end
  end

   def create
    hobo_create do |format|
      format.json { render json: this }
      format.html { hobo_create }
    end
  end

  def update
    hobo_update do |format|
      format.json { render json: this }
      format.html { hobo_update }
    end
  end

  def destroy
    hobo_destroy do |format|
      format.json { render json: this }
      format.html { hobo_destroy }
    end
  end
end