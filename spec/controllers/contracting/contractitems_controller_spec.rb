require 'spec_helper'

describe Contracting::ContractitemsController, :type => :controller do
  describe "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)

      @contract = create(:contract, consultant_id: @sales.id,
                                    customer_id: @user.id)
      @instance = create(:contractitem, contract_id: @contract.id,
                                        user_id: @user.id)
      @invalid_attributes = attributes_for(:contractitem, contract_id: nil,
                                                          user_id: nil)
    end

    it_behaves_like("crud actions")


    describe "json requests" do
      before :each do
        request.headers["accept"] = 'application/json'
      end


      describe 'GET #show' do
        it "renders json" do
          get :show, id: @instance
          expect(response.body).to be_json_eql({contractitem: @instance.attributes.merge({consumableitem_ids: []})}.to_json)
            .excluding(:contract_id, :product_id, :product_price, :toner_id, :user_id, :value, :volume)
        end
      end


      describe 'GET #index' do
        it "renders json" do
          get :index
          expect(response.body).to be_json_eql({contractitem: [@instance.attributes.merge({consumableitem_ids: []})]}.to_json)
            .excluding(:contract_id, :product_id, :product_price, :toner_id, :user_id, :value, :volume)
        end
      end


      describe 'POST #create' do
        it "renders json" do
          post :create, contractitem: attributes_for(:contractitem, contract_id: @contract.id,
                                                                    user_id: @user.id)
          expect(response.body).to be_json_eql({contractitem: @instance.attributes.merge({consumableitem_ids: []})}.to_json)
            .excluding(:contract_id, :product_id, :product_price, :toner_id, :user_id, :value, :volume)
        end
      end


      describe 'PATCH #update' do
        it "renders json" do
          patch :update, id: @instance.id,
                         contractitem:  attributes_for(:contractitem, contract_id: @contract.id,
                                                                      user_id: @user.id)
          expect(response.body).to be_json_eql({contractitem: @instance.attributes.merge({consumableitem_ids: []})}.to_json)
            .excluding(:contract_id, :product_id, :product_price, :toner_id, :user_id, :value, :volume)
        end
      end


      describe 'DELETE #destroy' do
        it "renders json" do
          delete :destroy, id: @instance
          expect(response.body).to be_json_eql({}.to_json)
        end
      end
    end
  end
end