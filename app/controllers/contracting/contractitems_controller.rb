class Contracting::ContractitemsController < Contracting::ContractingSiteController
  hobo_model_controller
  auto_actions :all

  def index
    hobo_index do |expects|
      expects.json { render json: this}
      expects.html { hobo_index }
    end
  end

  def show
    hobo_show do
      render json: this
  end

   def create
    hobo_create do
      render json: this
    end
  end

  def update
    hobo_update
      render json: this
    end
  end

  def destroy
    hobo_destroy
      render json: nil
  end
end