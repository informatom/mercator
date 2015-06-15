require 'spec_helper'

describe LineitemsController, :type => :controller do
  before :each do
    no_redirects and act_as_user
    @basket = create(:basket, user: @user)
    @product = create(:product_with_inventory_and_two_prices)
    @instance = create(:lineitem, user_id: @user.id,
                                  order_id: @basket.id,
                                  product_id: @product.id)

    request.env['HTTP_REFERER'] = users_path
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

    describe "PUT #do_delete_from_basket" do
      it "sets flash messages" do
        put :do_delete_from_basket, id: @instance.id
        expect(flash[:success]).to eql "The order position was deleted."
        expect(flash[:notice]).to eql nil
      end

      it "redirects_to return to" do
        put :do_delete_from_basket, id: @instance.id
        expect(response).to redirect_to users_path
      end
    end


    describe "PUT #do_transfer_to_basket" do
      it "sets flash messages" do
        put :do_transfer_to_basket, id: @instance.id
        expect(flash[:success]).to eql "The order position was copied into your current basket."
        expect(flash[:notice]).to eql nil
      end

      it "redirects_to return to" do
        put :do_transfer_to_basket, id: @instance.id
        expect(response).to redirect_to users_path
      end
    end



    describe "PUT #do_add_one" do
      it "sets flash messages" do
        put :do_add_one, id: @instance.id
        expect(flash[:success]).to eql "The amount was increased by one."
        expect(flash[:notice]).to eql nil
      end

      it "redirects_to return to" do
        put :do_transfer_to_basket, id: @instance.id
        expect(response).to redirect_to users_path
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
        expect(response).to redirect_to users_path
      end
    end


    describe "PUT #do_enable_upselling" do
      it "redirects_to return to" do
        @instance.update(upselling: false)
        put :do_enable_upselling, id: @instance.id
        expect(response).to redirect_to users_path
      end
    end


    describe "PUT #do_disable_upselling" do
      it "redirects_to return to" do
        put :do_disable_upselling, id: @instance.id
        expect(response).to redirect_to users_path
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
    end


    describe "PUT #do_transfer_to_basket", focus: true do
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
    end
  end
end