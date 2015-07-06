require 'spec_helper'

describe BillingAddressesController, :type => :controller do
  before :each do
    no_redirects and act_as_user
    @country = create(:country)
    @instance = create(:billing_address, country: @country.name_de,
                                         user_id: @user.id)
    @invalid_attributes = attributes_for(:billing_address, first_name: nil)
  end

  context "crud actions" do
    context "auto actions" do
      describe "GET #index_for_user" do
        it "renders index template" do
          get :index_for_user, user_id: @user.id
          expect(response.body).to render_template "billing_addresses/index_for_user"
        end
      end


      describe "GET #new_for_user" do
        it "renders new template" do
          get :new_for_user, user_id: @user.id
          expect(response.body).to render_template "billing_addresses/new_for_user"
        end
      end


      describe "POST #create_for_user" do
        it "redirects" do
          post :create_for_user, user_id: @user.id,
                                 billing_address: attributes_for(:billing_address, country: @country.name_de,
                                                                                   user_id: @user.id)
          expect(response).to be_redirect
        end
      end
    end


    describe "GET #edit" do
      it "sets the order_id" do
        get :edit, id: @instance.id,
                   order_id: 22
        expect(assigns(:billing_address).order_id).to eql "22" # This is a bit strange, why string?
      end
    end


    describe "POST #update" do
      it "updates mesonic, if enabled" do
        allow(Rails).to receive(:env) {"production"}
        expect_any_instance_of(User).to receive(:update_mesonic)
        post :update, id: @instance.id,
                      billing_address: attributes_for(:billing_address, country: @country.name_de,
                                                                        user_id: @user.id)
      end

      it "redirects to userpath" do
        post :update, id: @instance.id,
                      billing_address: attributes_for(:billing_address, country: @country.name_de,
                                                                        user_id: @user.id)
        expect(response).to redirect_to user_path(@user.id)
      end

      it "redirects to enter billing_addresses path, if order_id given" do
        @order = create(:order)
        post :update, id: @instance.id,
                      billing_address: attributes_for(:billing_address, country: @country.name_de,
                                                                        user_id: @user.id,
                                                                        order_id: @order.id)
        expect(response).to redirect_to enter_billing_addresses_path(order_id: @order.id)
      end
    end
  end


  context "lifecycle actions" do
    describe "GET #enter"  do
      it "is available" do
        expect(BillingAddress::Lifecycle.can_enter? @user).to be
      end

      it "creates an billing_address" do
        @order = create(:order)
        get :enter, id: @instance,
                    order_id: @order.id
        expect(assigns(:billing_address)).to be_a BillingAddress
      end

      it "sets the billing_address atributes for active users" do
        @order = create(:order)
        @user = create(:active_user)
        get :enter, id: @instance,
                    order_id: @order.id
        expect(assigns(:billing_address).user_id).to eql @user.id
        expect(assigns(:billing_address).order_id).to eql @order.id.to_s
        expect(assigns(:billing_address).email_address).to eql @user.email_address
        expect(assigns(:billing_address).gender).to eql @user.gender
        expect(assigns(:billing_address).title).to eql @user.title
        expect(assigns(:billing_address).first_name).to eql @user.first_name
        expect(assigns(:billing_address).surname).to eql @user.surname
        expect(assigns(:billing_address).email_address).to eql @user.email_address
        expect(assigns(:billing_address).phone).to eql @user.phone
      end

      it "sets billing address, if constant set" do
        create(:constant, key: "default_country",
                          value: "Österreich")
        @order = create(:order)
        @user = create(:active_user)
        get :enter, id: @instance,
                    order_id: @order.id
        expect(assigns(:billing_address).country).to eql @country.name_de
      end

      context "user had billing_address" do
        it "creates an billing_address" do
          @last_billing_address = create(:billing_address, user_id: @user.id)
          @order = create(:order)
          get :enter, id: @instance,
                      order_id: @order.id
          expect(assigns(:billing_address)).to be_a BillingAddress
        end

        it "sets the billing_address atributes" do
          @last_billing_address = create(:billing_address, user_id: @user.id)
          @order = create(:order)
          get :enter, id: @instance,
                      order_id: @order.id
          expect(assigns(:billing_address).user_id).to eql @user.id
          expect(assigns(:billing_address).order_id).to eql @order.id.to_s
          expect(assigns(:billing_address).gender).to eql "male"
          expect(assigns(:billing_address).title).to eql "Dr"
          expect(assigns(:billing_address).first_name).to eql "John"
          expect(assigns(:billing_address).surname).to eql "Doe"
          expect(assigns(:billing_address).detail).to eql "Department of Despair"
          expect(assigns(:billing_address).street).to eql "Kärntner Straße 123"
          expect(assigns(:billing_address).postalcode).to eql "1234"
          expect(assigns(:billing_address).city).to eql "Vienna"
          expect(assigns(:billing_address).country).to eql "Österreich"
          expect(assigns(:billing_address).phone).to eql "+43123456789"
        end
      end
    end


    describe "PUT #do_enter" do
      before :each do
        @order = create(:order, shipping_method: nil)
      end

      it "finds the order" do
        put :do_enter, id: @instance.id,
                       billing_address: attributes_for(:second_billing_address, order_id: @order.id)
        expect(assigns(:order)).to eql @order
      end

      it "updates the user relation" do
        put :do_enter, id: @instance.id,
                       billing_address: attributes_for(:second_billing_address, order_id: @order.id)
        expect(assigns(:billing_address).user_id).to eql @user.id
      end

      context "user is guest" do
        before :each do
          @user = create(:guest_user)
        end

        it "updates the current user attrirbutes" do
          put :do_enter, id: @instance.id,
                         billing_address: attributes_for(:second_billing_address, order_id: @order.id)

          expect(@user.gender).to eql        assigns(:billing_address).gender
          expect(@user.title).to eql         assigns(:billing_address).title
          expect(@user.first_name).to eql    assigns(:billing_address).first_name
          expect(@user.surname).to eql       assigns(:billing_address).surname
          expect(@user.email_address).to eql assigns(:billing_address).email_address
          expect(@user.phone).to eql         assigns(:billing_address).phone
        end

        it "mails the user the activation link" do
          expect(UserMailer).to receive_message_chain(:activation, :deliver)
          put :do_enter, id: @instance.id,
                         billing_address: attributes_for(:second_billing_address, order_id: @order.id)
        end

        context "user update fails" do
          it "removes the email address" do
            put :do_enter, id: @instance.id,
                           billing_address: attributes_for(:second_billing_address, order_id: @order.id,
                                                                                    email_address: nil)
            expect(assigns(:billing_address).email_address).to eql nil
          end

          it "sets the proper error message" do
            put :do_enter, id: @instance.id,
                           billing_address: attributes_for(:second_billing_address, order_id: @order.id,
                                                                                    email_address: nil)
            expect(assigns(:billing_address).errors.first).to eql [:email_address, "can't be blank"]
          end

          it "renders layout enter" do
            put :do_enter, id: @instance.id,
                           billing_address: attributes_for(:second_billing_address, order_id: @order.id,
                                                                                    email_address: nil)
            expect(response.body).to render_template :enter
          end
        end

        it "updates mesonic, if enabled and erp account number present" do
          @user.update(erp_account_nr: "some number")
          allow(Rails).to receive(:env) {"production"}
          expect_any_instance_of(User).to receive(:update_mesonic)

          put :do_enter, id: @instance.id,
                         billing_address: attributes_for(:second_billing_address, order_id: @order.id)
        end

        it "pushes to mesonic, if enabled and erp account number not" do
          @user.update(erp_account_nr: nil)
          allow(Rails).to receive(:env) {"production"}
          expect_any_instance_of(User).to receive(:push_to_mesonic)

          put :do_enter, id: @instance.id,
                         billing_address: attributes_for(:second_billing_address, order_id: @order.id)
        end
      end

      it "updates order attributes" do
        put :do_enter, id: @instance.id,
                       billing_address: attributes_for(:second_billing_address, order_id: @order.id)
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

        expect(assigns(:order).billing_company).to eql "small corp"
        expect(assigns(:order).billing_gender).to eql "female"
        expect(assigns(:order).billing_title).to eql "Mga"
        expect(assigns(:order).billing_first_name).to eql "Jane"
        expect(assigns(:order).billing_surname).to eql "Done"
        expect(assigns(:order).billing_detail).to eql "Department of Hope"
        expect(assigns(:order).billing_street).to eql "Sesame Street 1"
        expect(assigns(:order).billing_postalcode).to eql "5678"
        expect(assigns(:order).billing_city).to eql "Graz"
        expect(assigns(:order).billing_country).to eql "Österreich"
        expect(assigns(:order).billing_phone).to eql "+4311111111"
        expect(assigns(:order).billing_method).to eql :e_payment
      end

      it "sets shipping method, if not set" do
        @order.update(shipping_method: nil)
        put :do_enter, id: @instance.id,
                       billing_address: attributes_for(:second_billing_address, order_id: @order.id)
        expect(assigns(:order).shipping_method).to eql :parcel_service_shipment
      end

      it "creates an address" do
        put :do_enter, id: @instance.id,
                       billing_address: attributes_for(:second_billing_address, order_id: @order.id)
        expect(Address.first.company).to eql "small corp"
        expect(Address.first.gender).to eql "female"
        expect(Address.first.title).to eql "Mga"
        expect(Address.first.first_name).to eql "Jane"
        expect(Address.first.surname).to eql "Done"
        expect(Address.first.detail).to eql "Department of Hope"
        expect(Address.first.street).to eql "Sesame Street 1"
        expect(Address.first.postalcode).to eql "5678"
        expect(Address.first.city).to eql "Graz"
        expect(Address.first.country).to eql "Österreich"
        expect(Address.first.phone).to eql "+4311111111"
      end

      it "redirects to order path" do
        put :do_enter, id: @instance.id,
                       billing_address: attributes_for(:second_billing_address, order_id: @order.id)
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
        @billing_address = create(:second_billing_address, user_id: @user.id)
        put :do_use, id: @billing_address.id,
                     order_id: @order.id
        expect(assigns(:order).billing_company).to eql "small corp"
        expect(assigns(:order).billing_gender).to eql "female"
        expect(assigns(:order).billing_title).to eql "Mga"
        expect(assigns(:order).billing_first_name).to eql "Jane"
        expect(assigns(:order).billing_surname).to eql "Done"
        expect(assigns(:order).billing_detail).to eql "Department of Hope"
        expect(assigns(:order).billing_street).to eql "Sesame Street 1"
        expect(assigns(:order).billing_postalcode).to eql "5678"
        expect(assigns(:order).billing_city).to eql "Graz"
        expect(assigns(:order).billing_country).to eql "Österreich"
        expect(assigns(:order).billing_phone).to eql "+4311111111"
      end


      it "updates mesonic" do
        allow(Rails).to receive(:env) {"production"}
        expect_any_instance_of(User).to receive(:update_mesonic)
        put :do_use, id: @instance.id,
                     order_id: @order.id
      end

      it "sets billing method, if billing_method set" do
        @order.update(billing_method: nil)
        put :do_use, id: @instance.id,
                     order_id: @order.id
        expect(assigns(:order).billing_method).to eql :e_payment
      end

      it "sets shipping method, if shipping method and shipping company not set" do
        @order.update(shipping_company: nil, shipping_method: nil)
        put :do_use, id: @instance.id,
                     order_id: @order.id
        expect(assigns(:order).shipping_method).to eql :parcel_service_shipment
      end

      it "sets shipping attributes, if shipping_company not set" do
        @order.update(shipping_company: nil)
        @billing_address = create(:second_billing_address, user_id: @user.id)

        put :do_use, id: @billing_address.id,
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