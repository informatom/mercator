class Sales::ProductsController < Sales::SalesSiteController

  hobo_model_controller
  auto_actions :all, :lifecycle
  autocomplete :number, {:query_scope => :active_and_number_contains, limit: 25}

  def add_to_offer
    do_transition_action :add_to_offer do
      offer = Offer.find(session[:current_offer_id])
      added_item = offer.lifecycle.add_position!(current_user)
      added_item.update(product_id:     self.this.id,
                        product_number: self.this.number,
                        description_de: self.this.description_de,
                        description_en: self.this.description_en,
                        delivery_time:  self.this.delivery_time)
      added_item.new_pricing()

      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/offers/"+ offer.id.to_s,
                            type: "all")
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ offer.conversation_id.to_s,
                            type: "offers")
    end
  end
end