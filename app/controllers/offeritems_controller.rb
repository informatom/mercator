class OfferitemsController < ApplicationController

  hobo_model_controller

  auto_actions :lifecycle

  def do_copy
    do_transition_action :copy do
      last_position = current_basket.lineitems.*.position.max || 0
      @lineitem = Lineitem::Lifecycle.from_offeritem(current_user,
                                                     position:       last_position + 10,
                                                     product_number: this.product_number,
                                                     product_id:     this.product_id,
                                                     vat:            this.vat,
                                                     order_id:       current_basket.id,
                                                     user_id:        current_user.id,
                                                     description_de: this.description_de,
                                                     description_en: this.description_en,
                                                     amount:         this.amount,
                                                     product_price:  this.product_price,
                                                     value:          this.value,
                                                     unit:           this.unit,
                                                     delivery_time:  this.delivery_time)
      if @lineitem.save
        flash[:success] = "Die Angebotsposition wurde in den Warenkorb übernommen."
        flash[:notice] = nil
      end
      PrivatePub.publish_to("/orders/"+ current_basket.id.to_s, type: "basket")
      redirect_to session[:return_to]
    end
  end
end