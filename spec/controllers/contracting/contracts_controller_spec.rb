require 'spec_helper'

describe Contracting::ContractsController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)

      @instance = create(:contract, consultant_id: @sales.id,
                                    customer_id: @user.id)
    end

    it_behaves_like("crud index")


    describe "GET #index" do
      it "returns the correct json" do
        @conversation = create(:conversation, customer_id: @instance.customer_id,
                                              consultant_id: @instance.consultant_id)
        create(:second_contract, customer_id: @instance.customer_id,
                                 consultant_id: @instance.consultant_id,
                                 conversation_id: @conversation.id)

        get :index, format: :text
        expect(response.body).to be_json_eql( {records: [ { consultant: "Mr. Dr Sammy Sales Representative",
                                                            conversation: nil,
                                                            customer: "Mr. Dr John Doe",
                                                            enddate: "2017-03-05",
                                                            recid: 1,
                                                            startdate: "2014-03-06",
                                                            term: 36 },
                                                          { consultant: "Mr. Dr Sammy Sales Representative",
                                                            conversation: "Freudliche Beratung",
                                                            customer: "Mr. Dr John Doe",
                                                            enddate: "2016-08-03",
                                                            recid: 2,
                                                            startdate: "2015-08-04",
                                                            term: 12 }
                                                        ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "POST #manage" do
      context "creating a new contract" do
        before :each do
          @second_customer = create(:dummy_customer)
          @second_sales = create(:second_sales)
          @second_conversation = create(:second_conversation, customer_id: @second_customer.id,
                                                              consultant_id: @second_sales.id)

          @params = {cmd: "save-record",
                     recid: "0",
                     record: { consultant_id: @second_sales.id,
                               conversation_id: @second_conversation.id,
                               customer_id: @second_customer.id,
                               startdate: "2016-01-01",
                               term: 14 },
                     id: "0"}

          JsonSpec.configure {exclude_keys "created_at", "updated_at"}
        end

        after :each do
          JsonSpec.configure {exclude_keys "created_at", "updated_at", "id"}
        end

        it "creates a new contract if save record with recid 0" do
          post :manage, @params
          expect(assigns(:contract)).to be_a Contract
        end

        it "sets the contract attributes" do
          post :manage, @params
          expect(assigns(:contract).consultant_id).to eq @second_sales.id
          expect(assigns(:contract).conversation_id).to eq @second_conversation.id
          expect(assigns(:contract).customer.id).to eq @second_customer.id
          expect(assigns(:contract).startdate).to eq Date.new(2016, 1, 1)
          expect(assigns(:contract).term).to eq 14
        end


        it "returns the correct json" do
          post :manage, @params
          expect(response.body).to be_json_eql({ record: { consultant: "sammy.second_sales@informatom.com",
                                                           consultant_id: @second_sales.id,
                                                           conversation: "Noch eine Konversation",
                                                           conversation_id: @second_conversation.id,
                                                           customer: "dummy.customer@informatom.com",
                                                           customer_id: @second_customer.id,
                                                           recid: 2,
                                                           startdate: "2016-01-01",
                                                           term: 14 },
                                                 status: "success"} .to_json)
        end
      end
    end


    describe "DELETE #delete" do
      it "finds the right contract" do
        post :delete, id: @instance.id
        expect(assigns(:contract)).to eql @instance
      end

      it "deletes the contract" do
        post :delete, id: @instance.id
        expect(Contract.where(id: @instance.id)).to be_empty
      end

      it "renders nothing" do
        post :delete, id: @instance.id
        expect(response.body).to eql(" ")
      end

      it "blocks deletetion, if there are contractitems" do
        create(:contractitem, contract_id: @instance.id,
                              user_id: @instance.customer_id)

        post :delete, id: @instance.id
        expect(Contract.find(@instance.id)).to eql @instance
      end
    end
  end
end