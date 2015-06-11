require 'spec_helper'

describe AddressesController, :type => :controller do
  before :each do
    no_redirects and act_as_user
    @country = create(:country)
    @instance = create(:address, country: @country.name_de,
                                 user_id: @user.id)
    @invalid_attributes = attributes_for(:address, first_name: nil)
  end

  describe "crud actions" do
    it_behaves_like("crud except update")


    context "auto actions" do
      describe "GET #index_for_user" do
        it "renders index template" do
          get :index_for_user, user_id: @user.id
          expect(response.body).to render_template "addresses/index_for_user"
        end
      end


      describe "GET #new_for_user" do
        it "renders new template" do
          get :new_for_user, user_id: @user.id
          expect(response.body).to render_template "addresses/new_for_user"
        end
      end


      describe "POST #create_for_user" do
        it "redirects" do
          post :create_for_user, user_id: @user.id,
                                 address: attributes_for(:address, country: @country.name_de,
                                                                   user_id: @user.id)
          expect(response).to be_redirect
        end
      end
    end


    describe "GET #edit" do
      it "sets the order_id" do
        get :edit, id: @instance.id,
                   order_id: 22
        expect(assigns(:address).order_id).to eql "22" # This is a bit strange, why string?
      end
    end


    describe "POST #update"do
      it "redirects to userpath" do
        post :update, id: @instance.id,
                      address: attributes_for(:address, country: @country.name_de,
                                                        user_id: @user.id)
        expect(response).to redirect_to user_path(@user.id)
      end

      it "redirects to enter addresses path, if order_id given" do
        @order = create(:order)
        post :update, id: @instance.id,
                      address: attributes_for(:address, country: @country.name_de,
                                                        user_id: @user.id,
                                                        order_id: @order.id)
        expect(response).to redirect_to enter_addresses_path(order_id: @order.id)
      end
    end
  end


  context "lifecycle actions" do
    describe "GET #enter"  do
      it "is available" do
        expect(Address::Lifecycle.can_enter? @user).to be
      end

      it "creates an address" do
        @order = create(:order)
        get :enter, id: @instance,
                    order_id: @order.id
        expect(assigns(:address)).to be_an Address
      end

      it "sets the address atributes" do
        @order = create(:order)
        get :enter, id: @instance,
                    order_id: @order.id
        expect(assigns(:address).user_id).to eql @user.id
        expect(assigns(:address).order_id).to eql @order.id.to_s
      end

      context "user had address" do
        it "creates an address" do
          @last_address = create(:address, user_id: @user.id)
          @order = create(:order)
          get :enter, id: @instance,
                      order_id: @order.id
          expect(assigns(:address)).to be_an Address
        end

        it "sets the address atributes" do
          @last_address = create(:address, user_id: @user.id)
          @order = create(:order)
          get :enter, id: @instance,
                      order_id: @order.id
          expect(assigns(:address).user_id).to eql @user.id
          expect(assigns(:address).order_id).to eql @order.id.to_s
          expect(assigns(:address).gender).to eql "male"
          expect(assigns(:address).title).to eql "Dr"
          expect(assigns(:address).first_name).to eql "John"
          expect(assigns(:address).surname).to eql "Doe"
          expect(assigns(:address).detail).to eql "Department of Despair"
          expect(assigns(:address).street).to eql "Kärntner Straße 123"
          expect(assigns(:address).postalcode).to eql "1234"
          expect(assigns(:address).city).to eql "Vienna"
          expect(assigns(:address).country).to eql "Österreich"
          expect(assigns(:address).phone).to eql "+43123456789"
        end
      end
    end


    describe "PUT #do_enter" do
      before :each do
        @order = create(:order)
      end

      it "finds the order" do
        put :do_enter, id: @instance.id,
                       address: attributes_for(:second_address, order_id: @order.id)
        expect(assigns(:order)).to eql @order
      end

      it "updates the user" do
        put :do_enter, id: @instance.id,
                       address: attributes_for(:second_address, order_id: @order.id)
        expect(assigns(:address).user_id).to eql @user.id
      end

      it "updates order attributes" do
        put :do_enter, id: @instance.id,
                       address: attributes_for(:second_address, order_id: @order.id)
        expect(assigns(:order).shipping_company).to eql "small corp"
        expect(assigns(:order).shipping_gender).to eql "female"
        expect(assigns(:order).shipping_title).to eql "Mga"
        expect(assigns(:order).shipping_first_name).to eql "Jane"
        expect(assigns(:order).shipping_surname).to eql "Done"
        expect(assigns(:order).shipping_detail).to eql "Department of Hope"
        expect(assigns(:order).shipping_street).to eql "Sesame Street 1"
        expect(assigns(:order).shipping_postalcode).to eql "5678"
        expect(assigns(:order).shipping_city).to eql "Graz"
        expect(assigns(:order).shipping_country).to eql "Österreich"
        expect(assigns(:order).shipping_phone).to eql "+4311111111"
      end

      it "sets shipping method, if not set" do
        @order.update(shipping_method: nil)
        put :do_enter, id: @instance.id,
                       address: attributes_for(:second_address, order_id: @order.id)
        expect(assigns(:order).shipping_method).to eql :parcel_service_shipment
      end

      it "redirects to order path"  do
        put :do_enter, id: @instance.id,
                       address: attributes_for(:second_address, order_id: @order.id)
        expect(response).to redirect_to order_path(@order)
      end
    end


    describe "PUT #do_use" do
      before :each do
        @order = create(:order)
      end

      it "is available for active" do
        @instance.state = "active"
        expect(@instance.lifecycle.can_use? @user).to be
      end

      it "finds the order" do
        put :do_use, id: @instance.id,
                     order_id: @order.id
        expect(assigns(:order)).to eql @order
      end

      it "updates order parameters" do
        @new_address = create(:second_address, user_id: @user.id)
        put :do_use, id: @new_address.id,
                     order_id: @order.id
        expect(assigns(:order).shipping_company).to eql "small corp"
        expect(assigns(:order).shipping_gender).to eql "female"
        expect(assigns(:order).shipping_title).to eql "Mga"
        expect(assigns(:order).shipping_first_name).to eql "Jane"
        expect(assigns(:order).shipping_surname).to eql "Done"
        expect(assigns(:order).shipping_detail).to eql "Department of Hope"
        expect(assigns(:order).shipping_street).to eql "Sesame Street 1"
        expect(assigns(:order).shipping_postalcode).to eql "5678"
        expect(assigns(:order).shipping_city).to eql "Graz"
        expect(assigns(:order).shipping_country).to eql "Österreich"
        expect(assigns(:order).shipping_phone).to eql "+4311111111"
      end

      it "sets shipping method, if not set" do
        @order.update(shipping_method: nil)
        put :do_use, id: @instance.id,
                     order_id: @order.id
        expect(assigns(:order).shipping_method).to eql :parcel_service_shipment
      end

      it "redirects to order path" do
        put :do_use, id: @instance.id,
                     order_id: @order.id
        expect(response).to redirect_to order_path(@order)
      end
    end

    describe "PUT #do_trash" do
      it "is available for active" do
        @instance.state = "active"
        expect(@instance.lifecycle.can_trash? @user).to be
      end

      it "deletes the record" do
        @order = create(:order)
        put :do_trash, id: @instance.id,
                       order_id: @order.id
      end

      it "redirects to enter addresses path" do
        @order = create(:order)
        put :do_trash, id: @instance.id,
                       order_id: @order.id
        enter_addresses_path(order_id: @order.id)
      end
    end
  end
end