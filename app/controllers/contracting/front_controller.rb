class Contracting::FrontController < Contracting::ContractingSiteController

  hobo_controller

  def index; end


  def search
    if params[:query]
      site_search(params[:query])
    end
  end
end