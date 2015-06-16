require 'spec_helper'

describe Sales::OfferitemsController, :type => :controller do
  describe "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @user = create(:user)
      @conversation = create(:conversation, customer_id: @user.id,
                                            consultant_id: @sales.id)
      @offer = create(:offer, complete: false,
                              state: "valid",
                              user_id: @user.id,
                              conversation_id: @conversation.id)
      @product = create(:product_with_inventory_and_two_prices)
      @instance = create(:offeritem, offer_id: @offer.id,
                                      user_id: @user.id)

      @invalid_attributes = attributes_for(:offeritem, position: nil,
                                                       offer_id: @offer.id,
                                                       user_id: @user.id)
      request.env['HTTP_REFERER'] = categories_path
    end


    it_behaves_like("crud actions")


    describe 'PATCH #update' do
      it "sets attributes for non existing product" do
        patch :update, id: @instance,
                       offeritem: { amount: 13,
                                    product_price: 13,
                                    discount_abs: 13,
                                    product_number: "invented" }

        expect(assigns(:this).amount).to eql 13
        expect(assigns(:this).product_price).to eql 13
        expect(assigns(:this).discount_abs).to eql 13
        expect(assigns(:this).product_number).to eql "invented"
      end

      it "determines price for non existing product" do
        patch :update, id: @instance,
                       offeritem: { amount: 13,
                                    product_price: 13,
                                    discount_abs: 1.3,
                                    product_number: "invented" }
        expect(assigns(:this).value).to eql 152.1
      end

      it "sets more attributes for an existing product" do
        patch :update, id: @instance,
                       offeritem: { amount: 13,
                                    product_price: 13,
                                    discount_abs: 1.3,
                                    product_number: @product.number }

        expect(assigns(:this).product_id).to eql @product.id
        expect(assigns(:this).description_de).to eql @product.description_de
        expect(assigns(:this).description_en).to eql @product.description_en
        expect(assigns(:this).delivery_time).to eql @product.delivery_time
      end

      it "runs a new pricing for an existing product" do
        patch :update, id: @instance,
                       offeritem: { amount: 13,
                                    product_price: 13,
                                    discount_abs: 13,
                                    product_number: @product.number }
        expect(assigns(:this).product_price).to eql 38
        expect(assigns(:this).value).to eql 325
      end

      it "publishes to offer and conversation" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/offers/"+ @instance.offer.id.to_s,
                                                        type: "all")
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @instance.offer.conversation.id.to_s,
                                                        type: "offers")
        patch :update, id: @instance,
                       offeritem: { amount: 13,
                                    product_price: 13,
                                    discount_abs: 1.3,
                                    product_number: @product.number }
      end
    end


    describe "PUT do_delete_frome_offer" do
      it "sets flash messages" do
        put :do_delete_from_offer, id: @instance.id
        expect(flash[:success]).to eql "The offer position was deleted."
        expect(flash[:notice]).to eql nil
      end

      it "publishes tof offer and conversation" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/offers/"+ @instance.offer.id.to_s,
                                                        type: "all")
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @instance.offer.conversation.id.to_s,
                                                        type: "offers")
        put :do_delete_from_offer, id: @instance.id
      end

      it "redirects to return to" do
        put :do_delete_from_offer, id: @instance.id
        expect(response).to redirect_to categories_path
      end

      it "is available for in_progress" do
        @instance.state = "in_progress"
        expect(@instance.lifecycle.can_delete_from_offer? @sales).to be
      end
    end


    describe "POST add" do
      it "is available" do
        @offer = create(:offer, user_id: @user.id,
                                consultant_id: @sales.id)
        expect(Offeritem::Lifecycle.can_add? @sales).to be
      end
    end
  end
end
