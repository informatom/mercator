class OffersController < ApplicationController
  before_filter :domain_shop_redirect
  after_filter :track_action

  hobo_model_controller
  auto_actions :show, :lifecycle


  show_action :refresh do
    self.this = Offer.find(params[:id])
    show_response
  end


  def do_copy
    do_transition_action :copy do
      last_position = current_basket.lineitems.*.position.max || 0
      if this.complete
        order = Order::Lifecycle.from_offer(
          current_user,
          user_id: current_user.id,
          billing_method:      Order::DEFAULT_BILLING_METHOD,
          billing_company:     this.billing_company,
          billing_gender:      this.billing_gender,
          billing_first_name:  this.billing_first_name,
          billing_surname:     this.billing_surname,
          billing_detail:      this.billing_detail,
          billing_street:      this.billing_street,
          billing_postalcode:  this.billing_postalcode,
          billing_city:        this.billing_city,
          billing_country:     this.billing_country,
          shipping_company:    this.shipping_company,
          shipping_gender:     this.shipping_gender,
          shipping_first_name: this.shipping_first_name,
          shipping_surname:    this.shipping_surname,
          shipping_detail:     this.shipping_detail,
          shipping_street:     this.shipping_street,
          shipping_postalcode: this.shipping_postalcode,
          shipping_city:       this.shipping_city,
          shipping_country:    this.shipping_country,
          discount_rel:        this.discount_rel
        )
        order.save

        this.offeritems.each_with_index do |offeritem, index|
          lineitem = Lineitem::Lifecycle.blocked_from_offeritem(
            current_user,
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
            delivery_time:  offeritem.delivery_time
          )
          lineitem.save
        end

        flash[:success] = I18n.t("mercator.messages.offer.copy_to_order.success")
        flash[:notice] = nil
        PrivatePub.publish_to("/" + CONFIG[:system_id] + "/orders/"+ current_basket.id.to_s,
                              type: "basket")
        redirect_to order_path(order)

      else
        this.offeritems.each_with_index do |offeritem, index|
          lineitem = Lineitem::Lifecycle.from_offeritem(
            current_user,
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
            delivery_time:  offeritem.delivery_time
          )
          lineitem.save
        end

        flash[:success] = I18n.t("mercator.messages.offer.copy_to_offer.success")
        flash[:notice] = nil
        PrivatePub.publish_to("/" + CONFIG[:system_id] + "/orders/"+ current_basket.id.to_s,
                              type: "basket")
        redirect_to order_path(current_basket)
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