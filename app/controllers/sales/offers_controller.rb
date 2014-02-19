class Sales::OffersController < Sales::SalesSiteController

  hobo_model_controller

  auto_actions :all, :lifecycle

  def build
    conversation = Conversation.find(session[:current_conversation_id])
    customer = conversation.customer
    self.this = Offer.new(consultant_id: conversation.consultant_id,
                          conversation_id: conversation.id,
                          user_id: conversation.customer_id)
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

end
