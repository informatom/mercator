require 'spec_helper'

describe Sales::OffersController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_sales

      @user = create(:user)
      @country = create(:country)
      create(:billing_address, user_id: @user.id,
                               country: @country.name_de)
      create(:address, user_id: @user.id,
                       country: @country.name_de)

      @conversation = create(:conversation, consultant_id: @sales.id,
                                            customer_id: @user.id)
      @instance = create(:offer, user_id: @user.id,
                                 consultant_id: @sales.id,
                                 conversation_id: @conversation.id)
      @invalid_attributes = attributes_for(:offer, valid_until: nil)
      session[:current_conversation_id] = @conversation.id
    end

    it_behaves_like("crud actions")


    describe "GET #show" do
      it "publishes to conversations" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @instance.conversation.id.to_s,
                                                        type: "suggestions")
        get :show, id: @instance.id
      end

      it "sets in session the current_offer_id" do
        get :show, id: @instance.id
        expect(session[:current_offer_id]).to eql(@instance.id)
      end
    end


    describe 'PATCH #update' do
      it "publishes to conversations and offers" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @instance.conversation.id.to_s,
                                                        type: "offers")
        expect(PrivatePub).to receive(:publish_to).with("/0004/offers/"+ @instance.id.to_s,
                                                        type: "all")

        patch :update, id: @instance, offer: { billing_company: "new compary" }
      end
    end


    describe "GET #build" do
      it "is available" do
        expect(Offer::Lifecycle.can_build? @sales).to be
      end

      it "creates a new offer" do
        get :build
        expect(assigns(:offer)).to be_an Offer
      end

      it "propagates a lot of attributes to offer" do
        get :build
        expect(assigns(:offer).consultant_id).to eql @sales.id
        expect(assigns(:offer).conversation_id).to eql @instance.conversation.id
        expect(assigns(:offer).user_id).to eql @user.id
        expect(assigns(:offer).valid_until).to eql Date.today + 1.month
        expect(assigns(:offer).billing_company).to eql "Bigcorp"
        expect(assigns(:offer).billing_gender).to eql "male"
        expect(assigns(:offer).billing_title).to eql "Dr"
        expect(assigns(:offer).billing_first_name).to eql "John"
        expect(assigns(:offer).billing_surname).to eql "Doe"
        expect(assigns(:offer).billing_detail).to eql "Department of Despair"
        expect(assigns(:offer).billing_street).to eql "Kärntner Straße 123"
        expect(assigns(:offer).billing_postalcode).to eql "1234"
        expect(assigns(:offer).billing_city).to eql "Vienna"
        expect(assigns(:offer).billing_country).to eql "österreich"
        expect(assigns(:offer).billing_phone).to eql "+43123456789"
        expect(assigns(:offer).shipping_company).to eql "Bigcorp"
        expect(assigns(:offer).shipping_gender).to eql "male"
        expect(assigns(:offer).shipping_title).to eql "Dr"
        expect(assigns(:offer).shipping_first_name).to eql "John"
        expect(assigns(:offer).shipping_surname).to eql "Doe"
        expect(assigns(:offer).shipping_detail).to eql "Department of Despair"
        expect(assigns(:offer).shipping_street).to eql "Kärntner Straße 123"
        expect(assigns(:offer).shipping_postalcode).to eql "1234"
        expect(assigns(:offer).shipping_city).to eql "Vienna"
        expect(assigns(:offer).shipping_country).to eql "österreich"
        expect(assigns(:offer).shipping_phone).to eql "+43123456789"
      end
    end


    describe "PUT #do_build" do
      before :each do
        @basket = create(:order, user_id: @user.id)
        @lineitem = create(:lineitem, order_id: @basket.id,
                                      user_id: @user.id)
        @attributes = { billing_company: "Bigcorp",
                        billing_gender: "Mr.",
                        billing_title: "Dr.",
                        billing_first_name: "Max",
                        billing_surname: "Mustermann",
                        billing_detail: "Finanzabteilung",
                        billing_street: "Musterstraße 123",
                        billing_postalcode: "1234",
                        billing_city: "Musterstadt",
                        billing_country: "Österreich",
                        billing_phone: "+43123456789",
                        shipping_company: "Bigcorp",
                        shipping_gender: "Mr.",
                        shipping_title: "Dr.",
                        shipping_first_name: "Max",
                        shipping_surname: "Mustermann",
                        shipping_detail: "Finanzabteilung",
                        shipping_street: "Musterstraße 123",
                        shipping_postalcode: "1234",
                        shipping_city: "Musterstadt",
                        shipping_country: "Österreich",
                        shipping_phone: "+43123456789",
                        user_id: @user.id,
                        consultant_id: @sales.id,
                        conversation_id: @conversation.id,
                        valid_until: Date.today + 1.month }

      end

      it "copies lineitems to offeritems" do
        put :do_build, offer: @attributes
        expect(assigns(:offer).offeritems.count).to eql 1
        expect(assigns(:offer).offeritems.first.position).to eql 10
        expect(assigns(:offer).offeritems.first.product_number).to eql "nr123"
        expect(assigns(:offer).offeritems.first.vat).to eql 20
        expect(assigns(:offer).offeritems.first.user_id).to eql @user.id
        expect(assigns(:offer).offeritems.first.description_de).to eql "Artikel Eins Zwei Drei"
        expect(assigns(:offer).offeritems.first.description_en).to eql "Article One Two Three"
        expect(assigns(:offer).offeritems.first.product_price).to eql 123.45
        expect(assigns(:offer).offeritems.first.value).to eql 5184.90
        expect(assigns(:offer).offeritems.first.unit).to eql "Stück"
        expect(assigns(:offer).offeritems.first.delivery_time).to eql "One week"
      end

      it "deletes the copied lineitems" do
        expect(@basket.lineitems.count).to eql 1
        put :do_build, offer: @attributes
        @basket.reload
        expect(@basket.lineitems.count).to eql 0
      end

      it "publishes_to conversation" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/conversations/"+ @instance.conversation.id.to_s,
                                                        type: "offers")
        put :do_build, offer: @attributes
      end
    end


    describe "GET #add_position" do
      it "is available" do
        expect(@instance.lifecycle.can_add_position? @sales).to be
      end

      it "creates a new offeritem" do
        @instance.lifecycle.add_position!(@sales)
        expect(@instance.offeritems.count).to eql 1
      end

      it "sets the attributes" do
        @instance.lifecycle.add_position!(@sales)
        @instance.reload
        @offeritem = @instance.offeritems.first
        expect(@offeritem.position).to eql 10
        expect(@offeritem.vat).to eql 20
        expect(@offeritem.offer_id).to eql @instance.id
        expect(@offeritem.user_id).to eql @user.id
        expect(@offeritem.description_de).to eql "dummy"
        expect(@offeritem.amount).to eql 1
        expect(@offeritem.product_price).to eql 0
        expect(@offeritem.value).to eql 0
        expect(@offeritem.unit).to eql "Stk."
        expect(@offeritem.product_number).to eql "manuell"
      end
    end


    describe "PUT #do_submit " do
      it "is available for in progress" do
        expect(@instance.lifecycle.can_submit? @sales).to be
      end

      it "checks validìty" do
        @instance.update(valid_until: Date.today - 1.day)
        put :do_submit, id: @instance.id
        expect(response).to have_http_status 403
      end

      it "publishes to offers" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/offers/"+ @instance.id.to_s,
                                                        type: "all")
        put :do_submit, id: @instance.id
      end
    end


    describe "PUT #do_place" do
      context "in progress" do
        it "is available for in progress" do
          expect(@instance.lifecycle.can_place? @sales).to be
        end

        it "checks validìty" do
          @instance.update(valid_until: Date.today - 1.day)
          put :do_place, id: @instance.id
          expect(response).to have_http_status 403
        end

        it "publishes to offers" do
          expect(PrivatePub).to receive(:publish_to).with("/0004/offers/"+ @instance.id.to_s,
                                                          type: "all")
          put :do_place, id: @instance.id
        end
      end

      context "pending" do
        before :each do
          @pending_offer = create(:offer, user_id: @user.id,
                                          consultant_id: @sales.id,
                                          conversation_id: @conversation.id,
                                          state: "pending_approval")
          act_as_salesmanager
        end

        it "is not available for pending approval for sales" do
          expect(@pending_offer.lifecycle.can_place? @sales).to be false
        end

        it "is not available for pending approval for sales" do
          expect(@pending_offer.lifecycle.can_place? @salesmanager).to be
        end

        it "checks validìty" do
          @pending_offer.update(valid_until: Date.today - 1.day)
          put :do_place, id: @pending_offer.id
          expect(response).to have_http_status 403
        end

        it "publishes to offers" do
          expect(PrivatePub).to receive(:publish_to).with("/0004/offers/"+ @pending_offer.id.to_s,
                                                          type: "all")
          put :do_place, id: @pending_offer.id
        end
      end
    end


    describe "PUT #do_devalidate" do
      before :each do
        @not_valid_offer = create(:offer, user_id: @user.id,
                                          consultant_id: @sales.id,
                                          conversation_id: @conversation.id,
                                          state: "valid",
                                          valid_until: Date.today - 1.day)
        act_as_user
      end

      it "is available for not any more valid approval" do
        expect(@not_valid_offer.lifecycle.can_devalidate? @user).to be
      end

      it "is not available for valid approval" do
        @not_valid_offer.update(valid_until: Date.today + 1.day)
        @valid_offer = @not_valid_offer
        expect(@valid_offer.lifecycle.can_devalidate? @user).to be false
      end

      it "publishes to offers" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/offers/"+ @not_valid_offer.id.to_s,
                                                        type: "all")
        @not_valid_offer.lifecycle.devalidate!(@user)
      end
    end


    describe "PUT #do_revise" do
      before :each do
        @invalid_offer = create(:offer, user_id: @user.id,
                                        consultant_id: @sales.id,
                                        conversation_id: @conversation.id,
                                        state: "invalid")
      end

      it "is available invalid approval" do
        expect(@invalid_offer.lifecycle.can_revise? @sales).to be
      end

      it "publishes to offers" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/offers/"+ @invalid_offer.id.to_s,
                                                        type: "all")
        @invalid_offer.lifecycle.revise!(@sales)
      end
    end


    describe "GET #refresh" do
      it "loads the offer" do
        xhr :post, :refresh, id: @instance.id, render: "whatever"
        expect(assigns(:offer)).to eql @instance
      end

      it "renders nothing" do
        xhr :post, :refresh, id: @instance.id, render: "whatever"
        expect(response.body).to eql ""
      end
    end
  end
end