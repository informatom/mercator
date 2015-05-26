class Sales::FrontController < Sales::SalesSiteController

  hobo_controller

  def index; end

  def refresh
    render partial: "recent_conversations"
  end
end