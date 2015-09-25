require 'spec_helper'

describe Contracting::ContractsController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)
      @instance = create(:contract)
    end

    it_behaves_like("crud index")


    describe "GET #index" do
      it "returns the correct json" do
        @second_contract = create(:second_contract)

        get :index, format: :text
        expect(response.body).to be_json_eql( {records: [ { contractnumber:   "first contract number",
                                                            customer:         "Max Mustermann",
                                                            customer_account: "an account number",
                                                            enddate:          "2019-03-05",
                                                            recid:            @instance.id,
                                                            startdate:        "2014-03-06" },
                                                          { contractnumber:   "second contract number",
                                                            customer:         "John Doe",
                                                            customer_account: "another account number",
                                                            enddate:          "2020-08-03",
                                                            recid:            @second_contract.id,
                                                            startdate:        "2015-08-04" }
                                                        ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "POST #manage" do
      context "creating a new contract" do
        before :each do
          @params = {cmd: "save-record",
                     recid: "0",
                     record: { contractnumber:   "another contract number",
                               customer:         "Jane Doe",
                               customer_account: "Janes account number",
                               startdate:        "2016-01-01" },
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
          expect(assigns(:contract).contractnumber).to eq "another contract number"
          expect(assigns(:contract).customer).to eq "Jane Doe"
          expect(assigns(:contract).customer_account).to eq "Janes account number"
          expect(assigns(:contract).startdate).to eq Date.new(2016, 1, 1)
        end


        it "returns the correct json" do
          post :manage, @params
          expect(response.body).to be_json_eql({ record: { contractnumber:   "another contract number",
                                                           customer:         "Jane Doe",
                                                           customer_account: "Janes account number",
                                                           recid:            assigns(:contract).id,
                                                           startdate:        "2016-01-01"},
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
        create(:contractitem, contract_id: @instance.id)

        post :delete, id: @instance.id
        expect(Contract.find(@instance.id)).to eql @instance
      end
    end
  end
end