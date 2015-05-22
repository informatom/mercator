class Sales::FrontController < Sales::SalesSiteController

  hobo_controller

  def index
  end


  def refresh
    render partial: "recent_conversations"
  end


  def search
    if params[:query]
      site_search(params[:query])
    end
  end
end