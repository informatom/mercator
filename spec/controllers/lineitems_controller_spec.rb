require 'spec_helper'

describe LineitemsController, :type => :controller do
  before :each do
    no_redirects and act_as_user
    @basket = create(:basket, user: @user)
    @product = create(:product_with_inventory_and_two_prices)
    @instance = create(:lineitem, user_id: @user.id,
                                  order_id: @basket.id,
                                  product_id: @product.id)

    request.env['HTTP_REFERER'] = categories_path
    create(:constant_shipping_cost)
    create(:shipping_cost_article)

    @supply = create(:second_product)
    create(:supplyrelation, product_id: @product.id,
                            supply_id: @supply.id)
  end


  describe "crud actions" do
    it_behaves_like("crud destroy")
  end


  describe "lifecycle actions" do

    describe "PUT #do_add_one" do
      it "sets flash messages" do
        put :do_add_one, id: @instance.id
        expect(flash[:success]).to eql "The amount was increased by one."
        expect(flash[:notice]).to eql nil
      end

      it "redirects_to return to" do
        put :do_transfer_to_basket, id: @instance.id
        expect(response).to redirect_to categories_path
      end

      it "is available" do
        expect(@instance.lifecycle.can_add_one? @user).to be
      end

      it "is not available for a lineitem in another order" do
        @order = create(:order, state: "active",
                                user_id: @user.id)
        @lineitem = create(:lineitem, order_id: @order.id,
                                      user_id: @user.id)
        expect(@lineitem.lifecycle.can_add_one? @user).to be false
      end

      it "increases the amount" do
        expect {@instance.lifecycle.add_one!(@user)}.to change {@instance.amount}.by 1
      end

      it "publishes to orders" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/orders/"+ @basket.id.to_s,
                                                       type: "basket")
        @instance.lifecycle.add_one!(@user)
      end
    end


    describe "PUT #do_remove_one" do
      it "sets flash messages" do
        put :do_remove_one, id: @instance.id
        expect(flash[:success]).to eql "The amount was decreased by one."
        expect(flash[:notice]).to eql nil
      end

      it "redirects_to return to" do
        put :do_transfer_to_basket, id: @instance.id
        expect(response).to redirect_to categories_path
      end

       it "is available" do
        expect(@instance.lifecycle.can_remove_one? @user).to be
      end

      it "is not available for a lineitem in another order" do
        @order = create(:order, state: "active",
                                user_id: @user.id)
        @lineitem = create(:lineitem, order_id: @order.id,
                                      user_id: @user.id)
        expect(@lineitem.lifecycle.can_remove_one? @user).to be false
      end

      it "decreases the amount" do
        expect {@instance.lifecycle.remove_one!(@user)}.to change {@instance.amount}.by -1
      end

      it "deletes the lineitem if amount was 1" do
        @instance.update(amount: 1)
        @instance.lifecycle.remove_one!(@user)
        expect(Lineitem.where(id: @instance.id)).to be_empty
      end


      it "publishes to orders" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/orders/"+ @basket.id.to_s,
                                                       type: "basket")
        @instance.lifecycle.remove_one!(@user)
      end
    end


    describe "PUT #do_enable_upselling" do
      it "redirects_to return to" do
        @instance.update(upselling: false)
        put :do_enable_upselling, id: @instance.id
        expect(response).to redirect_to categories_path
      end


      context "state is active" do
        it "is available" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        upselling: false,
                                        state: "active")
          expect(@lineitem.lifecycle.can_enable_upselling? @user).to be
        end

        it "is not available if already upselling" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        state: "active")
          expect(@lineitem.lifecycle.can_enable_upselling? @user).to be false
        end

        it "is not available if lineitem's product has no supplies upselling" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        upselling: false,
                                        state: "active")
          @lineitem.product.supplyrelations.delete_all
          expect(@lineitem.lifecycle.can_enable_upselling? @user).to be false
        end

        it "is not available if lineitem has no product" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: nil,
                                        upselling: false,
                                        state: "active")
          expect(@lineitem.lifecycle.can_enable_upselling? @user).to be false
        end

        it "is not available if lineitem's order is not basket" do
          @second_order = create(:order, user_id: @user.id)
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @second_order.id,
                                        product_id: nil,
                                        upselling: false,
                                        state: "active")
          expect(@lineitem.lifecycle.can_enable_upselling? @user).to be false
        end

        it "changes upselling to true" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        upselling: false,
                                        state: "active")
          @lineitem.lifecycle.enable_upselling!(@user)
          expect(@lineitem.upselling).to eql true
        end
      end


      context "state is blocked" do
        it "is available" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        upselling: false,
                                        state: "blocked")
          expect(@lineitem.lifecycle.can_enable_upselling? @user).to be
        end

        it "is not available if already upselling" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        state: "blocked")
          expect(@lineitem.lifecycle.can_enable_upselling? @user).to be false
        end

        it "is not available if lineitem's product has no supplies upselling" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        upselling: false,
                                        state: "blocked")
          @lineitem.product.supplyrelations.delete_all
          expect(@lineitem.lifecycle.can_enable_upselling? @user).to be false
        end

        it "is not available if lineitem has no product" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: nil,
                                        upselling: false,
                                        state: "blocked")
          expect(@lineitem.lifecycle.can_enable_upselling? @user).to be false
        end

        it "is not available if lineitem's order is not basket" do
          @second_order = create(:order, user_id: @user.id)
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @second_order.id,
                                        product_id: nil,
                                        upselling: false,
                                        state: "blocked")
          expect(@lineitem.lifecycle.can_enable_upselling? @user).to be false
        end

        it "changes upselling to true" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        upselling: false,
                                        state: "blocked")
          @lineitem.lifecycle.enable_upselling!(@user)
          expect(@lineitem.upselling).to eql true
        end
      end
    end


    describe "PUT #do_disable_upselling" do
      it "redirects_to return to" do
        put :do_disable_upselling, id: @instance.id
        expect(response).to redirect_to categories_path
      end

      context "state is active" do
        it "is available" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        state: "active")
          expect(@lineitem.lifecycle.can_disable_upselling? @user).to be
        end

        it "is not available if not upselling" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        upselling: false,
                                        state: "active")
          expect(@lineitem.lifecycle.can_disable_upselling? @user).to be false
        end

        it "is not available if lineitem's order is not basket" do
          @second_order = create(:order, user_id: @user.id)
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @second_order.id,
                                        product_id: nil,
                                        state: "active")
          expect(@lineitem.lifecycle.can_disable_upselling? @user).to be false
        end

        it "changes upselling to false" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        state: "active")
          @lineitem.lifecycle.disable_upselling!(@user)
          expect(@lineitem.upselling).to eql false
        end
      end


      context "state is blocked" do
        it "is available" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        state: "blocked")
          expect(@lineitem.lifecycle.can_disable_upselling? @user).to be
        end

        it "is not available if not upselling" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        upselling: false,
                                        state: "blocked")
          expect(@lineitem.lifecycle.can_disable_upselling? @user).to be false
        end

        it "is not available if lineitem's order is not basket" do
          @second_order = create(:order, user_id: @user.id)
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @second_order.id,
                                        product_id: nil,
                                        state: "blocked")
          expect(@lineitem.lifecycle.can_disable_upselling? @user).to be false
        end

        it "changes upselling to false" do
          @lineitem = create(:lineitem, user_id: @user.id,
                                        order_id: @basket.id,
                                        product_id: @product.id,
                                        state: "blocked")
          @lineitem.lifecycle.disable_upselling!(@user)
          expect(@lineitem.upselling).to eql false
        end
      end
    end


    describe "POST #do_insert_shipping" do
      it "is available" do
        expect(Lineitem::Lifecycle.can_insert_shipping? @user).to be
      end

      it "has state shipping_costs" do
        @shipping_costs = Lineitem::Lifecycle.insert_shipping(@user)
        expect(@shipping_costs.state).to eql "shipping_costs"
      end
    end


    describe "POST #do_from_offeritem" do
      it "is available" do
        expect(Lineitem::Lifecycle.can_from_offeritem? @user).to be
      end

      it "has state active" do
        @lineitem = Lineitem::Lifecycle.from_offeritem(@user)
        expect(@lineitem.state).to eql "active"
      end
    end


    describe "POST #do_blocked_from_offeritem" do
      it "is available" do
        expect(Lineitem::Lifecycle.can_blocked_from_offeritem? @user).to be
      end

      it "has state active" do
        @lineitem = Lineitem::Lifecycle.blocked_from_offeritem(@user)
        expect(@lineitem.state).to eql "blocked"
      end
    end


    describe "PUT #do_delete_from_basket" do
      it "is available" do
        expect(@instance.lifecycle.can_delete_from_basket? @user).to be
      end

      it 'deletes the lineitem' do
        @instance.lifecycle.delete_from_basket!(@user)
        expect(Lineitem.where(id: @instance.id)).to be_empty
      end

      it "is not available for a lineitem in another order" do
        @order = create(:order, state: "active",
                                user_id: @user.id)
        @lineitem = create(:lineitem, order_id: @order.id,
                                      user_id: @user.id)
        expect(@lineitem.lifecycle.can_delete_from_basket? @user).to be false
      end

      it "sets flash messages" do
        put :do_delete_from_basket, id: @instance.id
        expect(flash[:success]).to eql "The order position was deleted."
        expect(flash[:notice]).to eql nil
      end

      it "redirects_to return to" do
        put :do_delete_from_basket, id: @instance.id
        expect(response).to redirect_to categories_path
      end
    end


    describe "PUT #do_transfer_to_basket" do
      before :each do
        @order = create(:order, state: "active",
                                user_id: @user.id)
        @lineitem = create(:lineitem, order_id: @order.id,
                                      user_id: @user.id)
      end

      it "is available for a lineitem in another order" do
        expect(@lineitem.lifecycle.can_transfer_to_basket? @user).to be
      end

      it "is not available for a lineitem from another user" do
        @second_user = create(:guest_user)
        @order.update(user_id: @second_user.id)
        @lineitem.update(user_id: @second_user.id)
        @order.reload
        @lineitem.reload
        expect(@lineitem.lifecycle.can_transfer_to_basket? @user).to be false
      end

      it "moves the lineitem over to the basket" do
        @lineitem.lifecycle.transfer_to_basket!(@user)
        expect(@lineitem.order_id).to be @basket.id
      end

      it "deletes the parked basket if it is obsolete" do
        @lineitem.lifecycle.transfer_to_basket!(@user)
        expect(Order.where(id: @order.id)).to be_empty
      end

      it "deletes the parked basket if it is not obsolete" do
        @another_lineitem = create(:lineitem, order_id: @order.id,
                                             user_id: @user.id,
                                             product_id: @supply.id)
        @lineitem.lifecycle.transfer_to_basket!(@user)
        expect(Order.find(@order.id)).to be_a Order
      end

      it "sets flash messages" do
        put :do_transfer_to_basket, id: @instance.id
        expect(flash[:success]).to eql "The order position was copied into your current basket."
        expect(flash[:notice]).to eql nil
      end

      it "redirects_to return to" do
        put :do_transfer_to_basket, id: @instance.id
        expect(response).to redirect_to categories_path
      end
    end
  end
end