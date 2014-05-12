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
        order = Order::Lifecycle.from_offer(current_user, user_id: current_user.id)
        order.save
        this.offeritems.each_with_index do |offeritem, index|
          lineitem = Lineitem::Lifecycle.blocked_from_offeritem(current_user,
                                                                 position: (index + 1) * 10,
                                                                 product_number: offeritem.product_number,
                                                                 product_id:     offeritem.product_id,
                                                                 vat:            offeritem.vat,
                                                                 order_id:       order.id,
                                                                 user_id:        current_user.id,
                                                                 description_de: offeritem.description_de,
                                                                 description_en: offeritem.description_en,
                                                                 amount:         offeritem.amount,
                                                                 product_price:  offeritem.product_price,
                                                                 discount_abs:   offeritem.discount_abs,
                                                                 value:          offeritem.value,
                                                                 unit:           offeritem.unit,
                                                                 delivery_time:  offeritem.delivery_time)
          lineitem.save
          flash[:success] = "Das Angebot wurde in eine neue Bestellung kopiert."
          flash[:notice] = nil
          PrivatePub.publish_to("/orders/"+ current_basket.id.to_s, type: "basket")
          redirect_to order_path(order)
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
                                                        discount_abs:   offeritem.discount_abs,
                                                        value:          offeritem.value,
                                                        unit:           offeritem.unit,
                                                        delivery_time:  offeritem.delivery_time)
          lineitem.save
          flash[:success] = "Das Angebot wurde in den Warenkorb übernommen."
          flash[:notice] = nil
          PrivatePub.publish_to("/orders/"+ current_basket.id.to_s, type: "basket")
          redirect_to session[:return_to]
        end
      end
    end
  end

  def show
    hobo_show do |format|
      format.pdf do
        render :template => "offers/pdf.dryml", :pdf => "offer", :page_size  => 'A4', :zoom => 0.8
      end
      format.html
    end
  end
end