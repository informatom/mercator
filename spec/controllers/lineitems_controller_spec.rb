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
  end
end