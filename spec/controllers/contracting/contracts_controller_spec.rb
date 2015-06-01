require 'spec_helper'

describe Contracting::ContractsController, :type => :controller do
  describe "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)

      @instance = create(:contract, consultant_id: @sales.id,
                                    customer_id: @user.id)
      @attributes = attributes_for(:contract, consultant_id: @sales.id,
                                              customer_id: @user.id)
    end

    it_behaves_like("crud show index new edit")
    it_behaves_like("crud destroy")


    describe 'PATCH #update' do
      it "with data it renders #show" do
        patch :update, id: @instance, contract: @attributes
        expect(response).to redirect_to contracting_contract_path(assigns(:contract))
      end
    end


    describe 'POST #create' do
      it "with data it renders #show" do
        post :create, contract: @attributes
        expect(response).to redirect_to contracting_contract_path(assigns(:contract))
      end
    end


    describe "json requests" do
      before :each do
        request.headers["accept"] = 'application/json'
      end


      describe 'GET #show' do
        it "renders json" do
          get :show, id: @instance
          expect(response.body).to be_json_eql({contract: @instance.attributes.merge({contractitem_ids: []})}.to_json)
            .excluding(:consultant_id, :conversation_id, :runtime, :customer_id)
        end
      end


      describe 'GET #index' do
        it "renders json" do
          get :index
          expect(response.body).to be_json_eql({contract: [@instance.attributes.merge({contractitem_ids: []})]}.to_json)
            .excluding(:consultant_id, :conversation_id, :runtime, :customer_id)
        end
      end


      describe 'POST #create' do
        it "renders json" do
          post :create, contract: @attributes
          expect(response.body).to be_json_eql({contract: @instance.attributes.merge({contractitem_ids: []})}.to_json)
            .excluding(:consultant_id, :conversation_id, :runtime, :customer_id)
        end
      end


      describe 'PATCH #update' do
        it "renders json" do
          patch :update, id: @instance.id, contract: @attributes
          expect(response.body).to be_json_eql({contract: @instance.attributes.merge({contractitem_ids: []})}.to_json)
            .excluding(:consultant_id, :conversation_id, :runtime, :customer_id)
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