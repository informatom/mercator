class Admin::PricesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

    def destroy
    hobo_destroy do
      render json: '{ status: "success" }' if request.xhr?
    end
  end
end