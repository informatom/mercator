class Admin::OffersController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def destroy
    hobo_destroy do
      redirect_to admin_offers_path  # better but still problematic
    end
  end
end