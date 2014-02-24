class OffersController < ApplicationController

  hobo_model_controller

  auto_actions :show, :lifecycle

  def refresh
    self.this = Offer.find(params[:id])
    hobo_show
  end

  def do_copy
    do_transition_action :copy do
      last_position = current_basket.lineitems.*.position.max || 0
      if this.complete
        this.offeritems.each_with_index do |offeritem, index|
          lineitem = Lineitem::Lifecycle.blocked_from_offeritem(current_user,
                                                        position:       last_position + (index + 1) * 10,
                                                        product_number: offeritem.product_number,
                                                        product_id:     offeritem.product_id,
                                                        vat:            offeritem.vat,
                                                        order_id:       current_basket.id,
                                                        user_id:        current_user.id,
                                                        description_de: offeritem.description_de,
                                                        description_en: offeritem.description_en,
                                                        amount:         offeritem.amount,
                                                        product_price:  offeritem.product_price,
                                                        value:          offeritem.value,
                                                        unit:           offeritem.unit,
                                                        delivery_time:  offeritem.delivery_time)
          lineitem.save
        end
      else
        this.offeritems.each_with_index do |offeritem, index|
          lineitem = Lineitem::Lifecycle.from_offeritem(current_user,
                                                        position:       last_position + (index + 1) * 10,
                                                        product_number: offeritem.product_number,
                                                        product_id:     offeritem.product_id,
                                                        vat:            offeritem.vat,
                                                        order_id:       current_basket.id,
                                                        user_id:        current_user.id,
                                                        description_de: offeritem.description_de,
                                                        description_en: offeritem.description_en,
                                                        amount:         offeritem.amount,
                                                        product_price:  offeritem.product_price,
                                                        value:          offeritem.value,
                                                        unit:           offeritem.unit,
                                                        delivery_time:  offeritem.delivery_time)
          lineitem.save
        end
      end
      flash[:success] = "Das Angebot wurde in den Warenkorb übernommen."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

end