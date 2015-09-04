require 'spec_helper'

describe Sales::ProductsController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_productmanager

      @instance = create(:product)
      @invalid_attributes = attributes_for(:product, title_de: nil).except(:state)
    end

    it_behaves_like("crud actions")
  end


  describe "lifecycle actions" do
    before :each do
      no_redirects and act_as_productmanager

      @instance = create(:product_with_inventory_and_two_prices)
      @conversation = create(:conversation)
      @offer = create(:offer, conversation: @conversation,
                              user: @conversation.customer,
                              consultant: @conversation.consultant)
    end

    describe "GET #add_to_offer" do
      before :each do
        request.session[:current_offer_id] = @offer.id
      end

      it "is available for active" do
        @instance.state = "active"
        expect(@instance.lifecycle.can_add_to_offer? @productmanager).to be
      end

      it "can be run" do
        get :add_to_offer, id: @instance.id
        expect(response).to redirect_to sales_product_path(@instance)
      end

      it "creates on offer position with attributes set" do
        get :add_to_offer, id: @instance.id
        expect(@offer.offeritems.count).to eql 1
        expect(@offer.offeritems.first.user).to eql @offer.user
        expect(@offer.offeritems.first.product_id).to eql @instance.id
        expect(@offer.offeritems.first.product_number).to eql @instance.number
        expect(@offer.offeritems.first.description_de).to eql @instance.description_de
        expect(@offer.offeritems.first.description_en).to eql @instance.description_en
        expect(@offer.offeritems.first.delivery_time).to eql @instance.delivery_time
      end

      it "has the pricing run" do
        expect_any_instance_of(Offeritem).to receive(:new_pricing)
        get :add_to_offer, id: @instance.id
      end

      it "published the offer and the conversation" do
        expect(PrivatePub).to receive(:publish_to).with("/" + CONFIG[:system_id] + "/offers/"+ @offer.id.to_s,
                                                        type: "all")
        expect(PrivatePub).to receive(:publish_to).with("/" + CONFIG[:system_id] + "/conversations/"+ @offer.conversation.id.to_s,
                                                        type: "offers")
        get :add_to_offer, id: @instance.id
      end
    end
  end
end