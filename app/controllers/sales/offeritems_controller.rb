class Sales::OfferitemsController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all, :lifecycle

  def update
    hobo_update do
      amount         = params[:offeritem][:amount]
      product_price  = params[:offeritem][:product_price]
      discount_abs   = params[:offeritem][:discount_abs]
      product_number = params[:offeritem][:product_number]

      @this.amount         = amount         if amount
      @this.product_price  = product_price  if product_price
      @this.discount_abs   = discount_abs   if discount_abs
      @this.product_number = product_number if product_number

      if product = Product.find_by(number: @this.product_number)
        @this.product_id     = product.id
        @this.description_de = product.description_de
        @this.description_en = product.description_en
        @this.delivery_time  = product.delivery_time
      end
      @this.save

      if params[:offeritem][:product_number] && product
        @this.new_pricing
      else
        @this.update(value: (@this.product_price - @this.discount_abs) * @this.amount)
      end
    end
    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/offers/"+ @this.offer_id.to_s,
                          type: "all")
    PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ @this.offer.conversation_id.to_s,
                          type: "offers")
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