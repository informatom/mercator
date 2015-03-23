class Sales::OfferitemsController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all, :lifecycle

  def update
    hobo_update do
      if params[:offeritem][:amount]
        @this.update(product_price: @this.product.price(amount: @this.amount)) if @this.product
        @this.update(value: @this.calculate_value)
      end

      if params[:offeritem][:product_price] || params[:offeritem][:discount_abs]
        @this.update(value: @this.calculate_value)
      end

      if params[:offeritem][:product_number]
        @this.update_from_product(product_number: @this.product_number,
                                  amount: @this.amount,
                                  discount_abs: @this.discount_abs)
      end
    end
    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/offers/"+ @this.offer_id.to_s,
                          type: "all")
  end

  def do_delete_from_offer
    do_transition_action :delete_from_offer do
      flash[:success] = I18n.t("mercator.messages.offeritem.delete_from_offer.success")
      flash[:notice] = nil
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/offers/"+ @this.offer_id.to_s,
                            type: "all")
      redirect_to session[:return_to]
    end
  end
end