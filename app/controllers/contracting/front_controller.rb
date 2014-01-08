class Contracting::FrontController < Contracting::ContractingSiteController

  hobo_controller

  def index; end

  def summary
    if !current_user.administrator? && !current_user.sales?
      redirect_to user_login_path
    end
  end

  def search
    if params[:query]
      site_search(params[:query])
    end
  end

end