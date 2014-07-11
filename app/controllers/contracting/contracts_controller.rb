class Contracting::ContractsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :all
  respond_to :html, :json

  def index
    hobo_index do |expects|
      expects.json { render json: this }
      expects.html { hobo_index }
    end
  end

  def show
    hobo_show do
      render json: this
    end
  end

   def create
    hobo_create do
      render json: this
    end
  end

  def update
    hobo_update do
      render json: this
    end
  end

  def destroy
    hobo_destroy do
      render json: this
    end
  end
end