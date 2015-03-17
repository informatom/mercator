class Admin::InventoriesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def destroy
    hobo_destroy do
      if request.xhr?
        render json: '{ status: "success" }'
      end
    end
  end
end