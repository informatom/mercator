require 'spec_helper'

describe Contracting::ConsumableitemsController, :type => :controller do
  describe "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)
      @contract = create(:contract, consultant_id: @sales.id,
                                    customer_id: @user.id)
      @contractitem = create(:contractitem, contract_id: @contract.id,
                                            user_id: @user.id)
      @instance = create(:consumableitem, contractitem_id: @contractitem.id)
      @invalid_attributes = attributes_for(:consumableitem, contractitem_id: nil)
    end

    it_behaves_like("crud actions")


    describe "json requests" do
      before :each do
        request.headers["accept"] = 'application/json'
      end


      describe 'GET #show' do
        it "renders json" do
          get :show, id: @instance
          expect(response.body).to be_json_eql(@instance.to_json).excluding("contractitem_id")
        end
      end


      describe 'GET #index' do
        it "renders json" do
          get :index
          expect(response.body).to be_json_eql({consumableitem: [@instance.attributes]}.to_json).excluding("contractitem_id")
        end
      end


      describe 'POST #create' do
        it "renders json" do
          post :create, consumableitem: attributes_for(:consumableitem, contractitem_id: @contractitem.id)
          expect(response.body).to be_json_eql(@instance.to_json).excluding("contractitem_id")
        end
      end


      describe 'PATCH #update' do
        it "renders json" do
          patch :update, id: @instance.id,
                         consumableitem:  attributes_for(:consumableitem, contractitem_id: @contractitem.id)
          expect(response.body).to be_json_eql(@instance.to_json).excluding("contractitem_id")
        end
      end


      describe 'DELETE #destroy' do
        it "renders json" do
          delete :destroy, id: @instance
          expect(response.body).to be_json_eql(@instance.to_json).excluding("contractitem_id")
        end
      end
    end
  end
end