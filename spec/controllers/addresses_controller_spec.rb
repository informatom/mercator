require 'spec_helper'

describe AddressesController, :type => :controller do

  describe "crud actions" do
    before :each do
      no_redirects and act_as_user
      @country = create(:country)
      @instance = create(:address, country: @country.name_de,
                                   user_id: @user.id)
      @invalid_attributes = attributes_for(:address, first_name: nil)
    end

    it_behaves_like("crud except update")


    context "auto actions" do
      describe "GET #index_for_user" do
        it "renders index template" do
          get :index_for_user, user_id: @user.id
          expect(response.body).to render_template "addresses/index_for_user"
        end
      end


      describe "GET #new_for_user" do
        it "renders new template" do
          get :new_for_user, user_id: @user.id
          expect(response.body).to render_template "addresses/new_for_user"
        end
      end


      describe "POST #create_for_user" do
        it "redirects" do
          post :create_for_user, user_id: @user.id,
                                 address: attributes_for(:address, country: @country.name_de,
                                                                   user_id: @user.id)
          expect(response).to be_redirect
        end
      end
    end


    describe "GET #edit", focus: true do
      it "sets the order_id" do
        get :edit, id: @instance.id,
                   order_id: 22
        expect(assigns(:address).order_id).to eql "22" # This is a bit strange, why string?
      end
    end
  end
end


# POST /users/:user_id/addresses(.:format) addresses#create_for_user