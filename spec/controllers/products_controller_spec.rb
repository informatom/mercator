require 'spec_helper'

describe ProductsController, :type => :controller do
  before :each do
    no_redirects and act_as_user
    @product = create(:product_with_inventory_and_two_prices)
    @inventory = @product.inventories.first
    request.env['HTTP_REFERER'] = users_path
  end


  describe "GET #show" do
    it "reads inventory if given" do
      get :show, id: @product.id, inventory_id: @inventory.id
      expect(assigns(:inventory)).to eql @inventory
    end

    it "redirects if state is new" do
      @product = create(:product_with_inventory_and_two_prices, state: "new",
                                                                number: "new product")
      get :show, id: @product.id
      expect(response).to have_http_status(303)
    end

    it "redirects if state is deprecated" do
      @product = create(:product_with_inventory_and_two_prices, state: "deprecated",
                                                                number: "deprecated product")
      get :show, id: @product.id
      expect(response).to have_http_status(303)
    end
  end


  describe "POST #refresh" do
    it "reads inventory if given" do
      post :refresh, id: @product.id, inventory_id: @inventory.id
      expect(assigns(:inventory)).to eql @inventory
    end
  end


  context "lifecycle actions" do
    describe "PUT #do_add_to_basket" do
      it "sets flash messages" do
        put :do_add_to_basket, id: @product.id
        expect(flash[:success]).to eql "The product was added to the basket."
        expect(flash[:notice]).to eql nil
      end

      it "redirects_to return to" do
        put :do_add_to_basket, id: @product.id
        expect(response).to redirect_to users_path
      end

      it "publishes the message" do
        expect(PrivatePub).to receive(:publish_to).with("/0004/orders/"+ @user.basket.id.to_s,
                                                        type: "basket")
        post :do_add_to_basket, id: @product.id
      end

      it "creates a basketline" do
        post :do_add_to_basket, id: @product.id
        expect(@user.basket.lineitems.count).to eql 1
      end
    end


    describe "PUT #do_compare" do
      it "adds id to session[:compared]" do
        post :do_compare, id: @product.id
        expect(session[:compared]).to match_array [@product.id]
      end

      it "sets flash messages" do
        put :do_compare, id: @product.id
        expect(flash[:success]).to eql "The product was added to the comparison sheet."
        expect(flash[:notice]).to eql nil
      end

      it "redirects_to return to" do
        put :do_compare, id: @product.id
        expect(response).to redirect_to users_path
      end
    end


    describe "PUT #do_dont_compare" do
      it "adds id to session[:compared]" do
        session[:compared] = [11, 22, 33, @product.id]
        post :do_dont_compare, id: @product.id
        expect(session[:compared]).to match_array [11, 22, 33]
      end

      it "sets flash messages" do
        put :do_dont_compare, id: @product.id
        expect(flash[:success]).to eql "The product was removed from the comparison sheet."
        expect(flash[:notice]).to eql nil
      end

      it "redirects_to return to" do
        put :do_dont_compare, id: @product.id
        expect(response).to redirect_to users_path
      end
    end


    describe "GET #comparison", focus: true do
      before :each do
        @filterable_property = create(:property, state: "filterable")
        @unfilterable_property = create(:property, state: "unfilterable")
        @first_product = create(:product_with_inventory_and_lower_price)
        create(:value, property_id: @filterable_property.id,
                       product_id: @first_product.id,
                       state: "textual",
                       amount: nil,
                       flag: nil)
        create(:value, property_id: @unfilterable_property.id,
                       product_id: @first_product.id,
                       state: "textual",
                       amount: nil,
                       flag: nil)

        @second_product = create(:product_with_inventory_and_two_prices, number: "second product")
        @second_value = create(:value, property_id: @filterable_property.id,
                                         product_id: @second_product.id,
                                         state: "textual",
                                         amount: nil,
                                         flag: nil,
                                         title_en: "searched Value")
        session[:compared] = [@first_product.id, @second_product.id]
      end

      it "reads the products" do
        get :comparison
        expect(assigns(:products)).to match_array [@first_product, @second_product]
      end

      it "assigns nested hash" do
        get :comparison
        expect(assigns(:nested_hash)).to eql({"property group" => { "property" => { 3 => "searched Value kg",
                                                                                    2 => "English Value kg" }}})
      end

      it "redirects if no products given" do
        session[:compared] = nil
        get :comparison
        expect(response).to be_redirect
      end
    end
  end
end