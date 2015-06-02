require 'spec_helper'

describe Sales::OffersController, :type => :controller do
  describe "crud actions" do
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


    describe "PUT #do_build", focus: true do
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


    describe "GET #refresh" do
      it "loads the offer" do
        get :refresh, id: @instance.id
        expect(assigns(:offer)).to eql @instance
      end

      it "renders show" do
        get :refresh, id: @instance.id
        expect(response).to render_template :show
      end
    end
  end
end