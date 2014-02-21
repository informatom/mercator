class Sales::OfferitemsController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all, :lifecycle

  def update
    hobo_update do
      if params[:offeritem][:amount]
        @this.update(product_price: @this.product.price(amount: @this.amount)) if @this.product
        @this.update(value:         @this.product_price * @this.amount)
      end

      if params[:offeritem][:product_price]
        @this.update(value: @this.product_price * @this.amount)
      end

      product_number = params[:offeritem][:product_number]
      @this.update_from_product(product_number: product_number, amount: @this.amount) if product_number
    end
    PrivatePub.publish_to("/offers/"+ @this.offer_id.to_s, type: "all")
  end

  def do_delete_from_offer
    do_transition_action :delete_from_offer do
      flash[:success] = "Die Angebotsposition wurde gelöscht."
      flash[:notice] = nil
      PrivatePub.publish_to("/offers/"+ @this.offer_id.to_s, type: "all")
      redirect_to session[:return_to]
    end
  end
end