require 'spec_helper'

describe ConsumablesController, :type => :controller do

  before :each do
    no_redirects and act_as_user
  end

  describe "products" do
    it "finds the printer" do
      get :products, id: 40088220
      expect(assigns(:printer)).to eql 40088220
    end

    it "finds the printer description" do
      get :products, id: 40088220
      expect(assigns(:printer_description)).to eql "test"
    end

    it "finds the products" do
      get :products, id: 40088220
      expect(assigns(:products)).to eql "test"
    end

    it "finds the active products" do
      get :products, id: 40088220
      expect(assigns(:active_products)).to eql "test"
    end

    it "finds the printerseries" do
      get :products, id: 40088220
      expect(assigns(:printerseries)).to eql "test"
    end
  end


  describe "printers" do
  end


  describe "category" do
  end
end