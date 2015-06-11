require 'spec_helper'

describe Admin::CategoriesController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_admin

      @instance = create(:category)
      @invalid_attributes = attributes_for(:category, position: nil)
    end

    it_behaves_like("crud actions")


    describe 'GET #index' do
      it "searches for name_de" do
        get :index, search: "Drucker"
        expect(assigns(:categories).count).to eql 1
      end

      it "searches for name_en" do
        get :index, search: "Printer"
        expect(assigns(:categories).count).to eql 1
      end

      it "searches for description_de" do
        get :index, search: "Tolle"
        expect(assigns(:categories).count).to eql 1
      end

      it "searches for description_en" do
        get :index, search: "Fantastic"
        expect(assigns(:categories).count).to eql 1
      end

      it "searches for state" do
        get :index, search: "active"
        expect(assigns(:categories).count).to eql 1
      end


      it "if term not searchable, nothing is returned" do
        get :index, search: "not findable"
        expect(assigns(:categories).count).to eql 0
      end
    end


    describe 'GET #edit' do
      it "sets cancelpath if product id given" do
        get :edit, id: @instance, product_manager: true
        expect(assigns(:cancelpath)).to eql productmanager_front_path(category_id: @instance.id)
      end
    end


    describe 'PATCH #update' do
      it "redirects to productmanager property manager path of this product if product id given" do
        patch :update, id: @instance, category: { name_de: "neuer Name" },
                       page_path: "http://mercator.informatom.com/path?product_manager=true"
        expect(response).to redirect_to productmanager_front_path(category_id: @instance.id)
      end
    end
  end


  describe "GET #edit_properties" do
    before :each do
      no_redirects and act_as_admin

      @filterable_property = create(:property, state: "filterable")
      @unfilterable_property = create(:property, state: "unfilterable")
      @category = create(:category)
      @product = create(:product)

      create(:categorization, product_id: @product.id,
                              category_id: @category.id)
      create(:value, property_id: @filterable_property.id,
                     product_id: @product.id,
                     state: "textual",
                     amount: nil,
                     flag: nil)
      create(:value, property_id: @unfilterable_property.id,
                     product_id: @product.id,
                     state: "textual",
                     amount: nil,
                     flag: nil)
    end

    it "reads the category" do
      get :edit_properties, id: @category.id
      expect(assigns(:category)).to eql @category
    end

    it "reads the filterable properties" do
      get :edit_properties, id: @category.id
      expect(assigns(:filterable_properties)).to eql [@filterable_property]
    end

    it "reads the unfilterable properties" do
      get :edit_properties, id: @category.id
      expect(assigns(:unfilterable_properties)).to eql [@unfilterable_property]
    end
  end


  describe "job actions" do
    before :each do
      User.send(:remove_const, :JOBUSER) # just to avoid warning in the next line
      User::JOBUSER = create(:jobuser)
      no_redirects and act_as_admin
    end

    describe "GET #deprecate" do
      it "calls deprecato on Categery" do
        expect(Category).to receive :deprecate
        get :deprecate
      end

      it "redirects to admin logentries path" do
        get :deprecate
        expect(response).to redirect_to admin_logentries_path
      end
    end


    describe "GET #reindex" do
      it "calls deprecato on Categery" do
        expect(Category).to receive :reindex
        get :reindex
      end

      it "redirects to admin logentries path" do
        get :reindex
        expect(response).to redirect_to admin_logentries_path
      end
    end
  end


  context "lifecycle actions" do
    before :each do
      no_redirects and act_as_productmanager
      @instance = create(:category)
    end

    describe "activate" do
      it "is available for new" do
        @instance.state = "new"
        expect(@instance.lifecycle.can_activate? @productmanager).to be
      end
    end


    describe "deactivate" do
      it "is available for active" do
        @instance.state = "active"
        expect(@instance.lifecycle.can_deactivate? @productmanager).to be
      end
    end


    describe "reactivate" do
      it "is available for deprecated" do
        @instance.state = "deprecated"
        expect(@instance.lifecycle.can_reactivate? @productmanager).to be
      end
    end


    describe "switch_off" do
      it "is available for deprecated" do
        @instance.state = "deprecated"
        expect(@instance.lifecycle.can_switch_off? @productmanager).to be
      end
    end

    describe "switch_on" do
      it "is available for switched_off" do
        @instance.state = "switched_off"
        expect(@instance.lifecycle.can_switch_on? @productmanager).to be
      end
    end
  end
end