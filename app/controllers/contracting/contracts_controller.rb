class Contracting::ContractsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :all
  respond_to :html, :json

  def default_serializer_options
    {root: "contract" }
  end

  def index
    hobo_index do |expects|
      expects.json { render json: this }
      expects.html { hobo_index }
    end
  end

  def show
    hobo_show do |format|
      format.json { render json: this }
      format.html {}
    end
  end

   def create
    hobo_create do|format|
      format.json { render json: this }
      format.html { hobo_create}
    end
  end

  def update
    hobo_update do|format|
      format.json { render json: this }
      format.html { hobo_update }
    end
  end

  def destroy
    hobo_destroy do|format|
      format.json { render json: {} }
      format.html { hobo_destroy }
    end
  end
end