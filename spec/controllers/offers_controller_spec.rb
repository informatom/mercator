require 'spec_helper'

describe OffersController, :type => :controller do

  describe "lifecycle actions" do
    before :each do
      no_redirects and act_as_user

      @product = create(:product)
      @sales = create(:sales)
      @offer = create(:offer, complete: false,
                              state: "valid",
                              user_id: @user.id,
                              consultant_id: @sales.id)
      @offeritem = create(:offeritem, offer_id: @offer.id,
                                      user_id: @user.id,
                                      product_id: @product.id)

      @basket = create(:order, user_id: @user.id)
      @lineitem = create(:lineitem, order_id: @basket.id,
                                    user_id: @user.id,
                                    product_id: @product.id)
    end


    describe "POST #refresh" do
      it "loads the offer" do
        xhr :post, :refresh, id: @offer.id, render: "whatever"
        expect(assigns(:offer)).to eql @offer
      end
    end


    describe "GET #show" do
      it "can create pdf" do
        get :show, id: @offer.id, format: :pdf
        expect(response).to render_template "offers/pdf.dryml"
      end
    end


    context "lifecycle actions" do
      describe "POST #do_copy" do
        before :each do
          @offer_in_progress = create(:offer, user_id: @user.id,
                                              consultant_id: @sales.id,
                                              state: "in_progress")
        end

        it "is not available for in progress" do
          expect(@offer_in_progress.lifecycle.can_copy? @user).to be false
        end

        it "is not available for valid" do
          expect(@offer.lifecycle.can_copy? @user).to be
        end

        it "checks validìty" do
          @offer.update(valid_until: Date.today - 1.day)
          put :do_copy, id: @offer.id
          expect(response).to have_http_status 403
        end

        it "derives the last position" do
          post :do_copy, id: @offer.id
          expect(assigns(:last_position)).to eql @lineitem.position
        end

        context "complete offer" do
          before :each do
            @offer.update(complete: true)
          end

          it "creates an order" do
            post :do_copy, id: @offer.id
            expect(assigns(:order)).to be_a Order
          end

          it "sets the order attributes" do
            post :do_copy, id: @offer.id
            expect(assigns(:order).user_id).to eql @user.id
            expect(assigns(:order).billing_method).to eql :e_payment

            expect(assigns(:order).billing_company).to eql @offer.billing_company
            expect(assigns(:order).billing_gender).to eql @offer.billing_gender
            expect(assigns(:order).billing_title).to eql @offer.billing_title
            expect(assigns(:order).billing_first_name).to eql @offer.billing_first_name
            expect(assigns(:order).billing_surname).to eql @offer.billing_surname
            expect(assigns(:order).billing_detail).to eql @offer.billing_detail
            expect(assigns(:order).billing_street).to eql @offer.billing_street
            expect(assigns(:order).billing_postalcode).to eql @offer.billing_postalcode
            expect(assigns(:order).billing_city).to eql @offer.billing_city
            expect(assigns(:order).billing_country).to eql @offer.billing_country
            expect(assigns(:order).billing_phone).to eql @offer.billing_phone

            expect(assigns(:order).shipping_company).to eql @offer.shipping_company
            expect(assigns(:order).shipping_gender).to eql @offer.shipping_gender
            expect(assigns(:order).shipping_title).to eql @offer.shipping_title
            expect(assigns(:order).shipping_first_name).to eql @offer.shipping_first_name
            expect(assigns(:order).shipping_surname).to eql @offer.shipping_surname
            expect(assigns(:order).shipping_detail).to eql @offer.shipping_detail
            expect(assigns(:order).shipping_street).to eql @offer.shipping_street
            expect(assigns(:order).shipping_postalcode).to eql @offer.shipping_postalcode
            expect(assigns(:order).shipping_city).to eql @offer.shipping_city
            expect(assigns(:order).shipping_country).to eql @offer.shipping_country
            expect(assigns(:order).shipping_phone).to eql @offer.shipping_phone
          end

          it "creates a lineitem" do
            post :do_copy, id: @offer.id
            expect(assigns(:order).lineitems.count).to eql 1
          end

          it "sets the lineitem properties" do
            post :do_copy, id: @offer.id
            @lineitem = assigns(:order).lineitems.first
            expect(@lineitem.position).to eql 10
            expect(@lineitem.product_number).to eql @offeritem.product_number
            expect(@lineitem.product_id).to eql @offeritem.product_id
            expect(@lineitem.vat).to eql @offeritem.vat
            expect(@lineitem.order_id).to eql assigns(:order).id
            expect(@lineitem.user_id).to eql @user.id
            expect(@lineitem.description_de).to eql @offeritem.description_de
            expect(@lineitem.description_en).to eql @offeritem.description_en
            expect(@lineitem.amount).to eql @offeritem.amount
            expect(@lineitem.product_price).to eql @offeritem.product_price
            expect(@lineitem.discount_abs).to eql @offeritem.discount_abs
            expect(@lineitem.value).to eql @offeritem.value
            expect(@lineitem.unit).to eql @offeritem.unit
            expect(@lineitem.delivery_time).to eql @offeritem.delivery_time
          end

          it "sets flash messages" do
            post :do_copy, id: @offer.id
            expect(flash[:success]).to eql "The offer was copied to a new order."
            expect(flash[:notice]).to eql nil
          end

          it "publishes to orders" do
            expect(PrivatePub).to receive(:publish_to).with("/0004/orders/"+ @basket.id.to_s,
                                                       type: "basket")
            post :do_copy, id: @offer.id

          end

          it "redirects to show order" do
            post :do_copy, id: @offer.id
            expect(response).to redirect_to order_path(assigns(:order))
          end
        end

        context "non complete offer" do
          it "creates a new basket item" do
            post :do_copy, id: @offer.id
            expect(@basket.lineitems.count).to eql 2
          end

          it "sets the lineitem properties" do
            post :do_copy, id: @offer.id
            @lineitem = @basket.lineitems.last
            expect(@lineitem.position).to eql 133
            expect(@lineitem.product_number).to eql @offeritem.product_number
            expect(@lineitem.product_id).to eql @offeritem.product_id
            expect(@lineitem.vat).to eql @offeritem.vat
            expect(@lineitem.order_id).to eql @basket.id
            expect(@lineitem.user_id).to eql @user.id
            expect(@lineitem.description_de).to eql @offeritem.description_de
            expect(@lineitem.description_en).to eql @offeritem.description_en
            expect(@lineitem.amount).to eql @offeritem.amount
            expect(@lineitem.product_price).to eql @offeritem.product_price
            expect(@lineitem.discount_abs).to eql @offeritem.discount_abs
            expect(@lineitem.value).to eql @offeritem.value
            expect(@lineitem.unit).to eql @offeritem.unit
            expect(@lineitem.delivery_time).to eql @offeritem.delivery_time
          end

          it "sets flash messages" do
            post :do_copy, id: @offer.id
            expect(flash[:success]).to eql "The offer positions were copied into your current basket."
            expect(flash[:notice]).to eql nil
          end

          it "publishes to orders" do
            expect(PrivatePub).to receive(:publish_to).with("/0004/orders/"+ @basket.id.to_s,
                                                       type: "basket")
            post :do_copy, id: @offer.id

          end

          it "redirects to show order" do
            post :do_copy, id: @offer.id
            expect(response).to redirect_to order_path(@basket)
          end
        end
      end
    end
  end
end