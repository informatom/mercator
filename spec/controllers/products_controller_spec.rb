require 'spec_helper'

describe ProductsController, :type => :controller do
  before :each do
    no_redirects and act_as_user
    @product = create(:product_with_inventory_and_two_prices)
    @inventory = @product.inventories.first
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


  describe "POST #refresh", focus: true do
    it "reads inventory if given" do
      post :refresh, id: @product.id, inventory_id: @inventory.id
      expect(assigns(:inventory)).to eql @inventory
    end
  end
end