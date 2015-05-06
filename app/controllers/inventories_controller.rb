class InventoriesController < ApplicationController
  before_filter :domain_shop_redirect
  after_filter :track_action

  hobo_model_controller
  show_action :add_to_basket


  def add_to_basket
    inventory = Inventory.find(params[:id])
    current_user.basket.add_inventory(inventory: inventory)

    flash[:success] = I18n.t("mercator.messages.product.add_to_basket.success")
    flash[:notice] = nil

    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/orders/"+ current_basket.id.to_s,
                          type: "basket")

    redirect_to session[:return_to]
  end
end