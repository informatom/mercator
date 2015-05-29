require 'spec_helper'

describe InventoriesController, :type => :controller do
  describe "lifecycle actions" do
    before :each do
      no_redirects and act_as_user
      request.env['HTTP_REFERER'] = users_path

      @instance = create(:inventory_with_two_prices)
      @order = create(:basket, user: @user)
    end

    describe "GET #add_to_basket" do
      it "can be run" do
        get :add_to_basket, id: @instance.id
        expect(response).to redirect_to users_path
      end

      it "creates on order position with attributes set" do
        get :add_to_basket, id: @instance.id
        expect(@order.lineitems.count).to eql 1
      end

      it "has the flash set" do
        get :add_to_basket, id: @instance.id
        expect(flash[:success]).to eql "The product was added to the basket."
        expect(flash[:notice]).to eql nil
      end

      it "published the offer and the conversation" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/orders/"+ @order.id.to_s,
                                                        type: "basket")
        get :add_to_basket, id: @instance.id
      end
    end
  end
end