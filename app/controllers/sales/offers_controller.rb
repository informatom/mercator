class Sales::OffersController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all, :lifecycle

  def build
    conversation = Conversation.find(session[:current_conversation_id])
    customer = conversation.customer
    self.this = Offer.new(consultant_id: conversation.consultant_id,
                          conversation_id: conversation.id,
                          user_id: conversation.customer_id,
                          valid_until: Date.today + 1.month)

    billing_address = customer.billing_addresses.recent(1)[0]

    self.this.assign_attributes(billing_name: billing_address.name,
                                 billing_detail: billing_address.detail,
                                 billing_street: billing_address.street,
                                 billing_postalcode: billing_address.postalcode,
                                 billing_city: billing_address.city,
                                 billing_country: billing_address.country) if billing_address

    shipping_address = customer.addresses.recent(1)[0]
    self.this.assign_attributes(shipping_name: shipping_address.name,
                                 shipping_detail: shipping_address.detail,
                                 shipping_street: shipping_address.street,
                                 shipping_postalcode: shipping_address.postalcode,
                                 shipping_city: shipping_address.city,
                                 shipping_country: shipping_address.country) if shipping_address
    creator_page_action :build
  end

  def do_build
    do_creator_action :build do
      @this.user.basket.lineitems.each_with_index do |lineitem, index|
        @offeritem = Offeritem::Lifecycle.add(current_user,
                                              position:       (index + 1) * 10,
                                              product_number: lineitem.product_number,
                                              product_id:     lineitem.product_id,
                                              vat:            lineitem.vat,
                                              offer_id:       @this.id,
                                              user_id:        @this.user_id,
                                              description_de: lineitem.description_de,
                                              description_en: lineitem.description_en,
                                              amount:         lineitem.amount,
                                              product_price:  lineitem.product_price,
                                              value:          lineitem.value,
                                              unit:           lineitem.unit,
                                              delivery_time:  lineitem.delivery_time)
        if @offeritem.save
          lineitem.delete
        end
      end
      PrivatePub.publish_to("/conversations/"+ @this.conversation_id.to_s, type: "offers")
    end
  end

  def update
    hobo_update do
      if params[:offer][:shipping_name]
        PrivatePub.publish_to("/conversations/"+ @this.conversation_id.to_s, type: "offers")
      end
    end
    PrivatePub.publish_to("/offers/"+ @this.id.to_s, type: "all")
  end
end