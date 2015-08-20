require 'spec_helper'

describe Contracting::ConsumableitemsController, :type => :controller do
  context "crud actions" do
    before :each do
      no_redirects and act_as_sales
      @user = create(:user)
      @contract = create(:contract)
      @contractitem = create(:contractitem, contract_id: @contract.id)
      @instance = create(:consumableitem, contractitem_id: @contractitem.id)
    end

    it_behaves_like("crud index")


    describe "GET #index" do
      it "returns the correct json" do
        @second_consumableitem = create(:second_consumableitem, contractitem_id: @instance.contractitem_id)

        get :index, contractitem_id: @instance.contractitem_id, format: :text
        expect(response.body).to be_json_eql( {records: [ { amount: 1,
                                                            balance1: "-41.25",
                                                            balance2: "0.0",
                                                            balance3: "13.749999999999999996",
                                                            balance4: "13.750000000000000004000000004",
                                                            balance5: "13.749999999999999999999999996",
                                                            balance6: "99.99",
                                                            consumption1: 3,
                                                            consumption2: 4,
                                                            consumption3: 5,
                                                            consumption4: 6,
                                                            consumption5: 7,
                                                            consumption6: 8,
                                                            contract_type: "standard",
                                                            description_de: "ein Verbrauchsmaterial",
                                                            description_en: "a consumaeble item",
                                                            monthly_rate: "6.875",
                                                            new_rate2: "3.4375",
                                                            new_rate3: "3.4375",
                                                            new_rate4: "4.583333333333333333",
                                                            new_rate5: "5.729166666666666666666666667",
                                                            new_rate6: "6.875",
                                                            position: 1,
                                                            price: "13.75",
                                                            product_line: "shiny",
                                                            product_number: "123",
                                                            recid: @instance.id,
                                                            term: 2,
                                                            theyield: 12000,
                                                            value: "13.75",
                                                            wholesale_price: "12.5" },
                                                          { amount: 2,
                                                            balance1: "0.0",
                                                            balance2: "106.92",
                                                            balance3: "-35.64",
                                                            balance4: "-35.64",
                                                            balance5: "-35.64",
                                                            balance6: "66.55",
                                                            consumption1: 5,
                                                            consumption2: 4,
                                                            consumption3: 3,
                                                            consumption4: 2,
                                                            consumption5: 1,
                                                            consumption6: 2,
                                                            contract_type: "alternative",
                                                            description_de: "ein anderes Verbrauchsmaterial",
                                                            description_en: "a different consumaeble item",
                                                            monthly_rate: "5.94",
                                                            new_rate2: "5.94",
                                                            new_rate3: "14.85",
                                                            new_rate4: "11.88",
                                                            new_rate5: "8.91",
                                                            new_rate6: "5.94",
                                                            position: 2,
                                                            price: "35.64",
                                                            product_line: "brass",
                                                            product_number: "another product number",
                                                            recid: @second_consumableitem.id,
                                                            term: 12,
                                                            theyield: 1200,
                                                            value: "71.28",
                                                            wholesale_price: "32.4" }
                                                        ],
                                               status: "success",
                                               total: 2 }.to_json)
      end
    end


    describe "POST #manage" do
      context "creating a new consumableitem" do
        before :each do
          @second_customer = create(:dummy_customer)
          @second_product = create(:second_product)
          @second_toner = create(:second_toner)

          @params = {cmd: "save-record",
                     recid: "0",
                     record: { position: 87,
                               contract_type: "different",
                               product_number: "different product number",
                               product_line: "cool",
                               description_de: "schon wieder eine Beschreibung",
                               description_en: "yet another description",
                               amount: 71,
                               wholesale_price: 43.21,
                               term: 18,
                               balance6: 98.76,
                               consumption1: 8,
                               consumption2: 7,
                               consumption3: 6,
                               consumption4: 5,
                               consumption5: 4,
                               consumption6: 3,
                               contractitem_id: @instance.contractitem_id},
                     id: "0"}

          JsonSpec.configure {exclude_keys "created_at", "updated_at"}
        end

        after :each do
          JsonSpec.configure {exclude_keys "created_at", "updated_at", "id"}
        end

        it "creates a new consumableitem if save record with recid 0" do
          post :manage, @params
          expect(assigns(:consumableitem)).to be_a Consumableitem
        end

        it "sets the consumableitem attributes" do
          post :manage, @params
          expect(assigns(:consumableitem).position).to eq 87
          expect(assigns(:consumableitem).contract_type).to eq "different"
          expect(assigns(:consumableitem).product_number).to eq "different product number"
          expect(assigns(:consumableitem).product_line).to eq "cool"
          expect(assigns(:consumableitem).description_de).to eq "schon wieder eine Beschreibung"
          expect(assigns(:consumableitem).description_en).to eq "yet another description"
          expect(assigns(:consumableitem).amount).to eq 71
          expect(assigns(:consumableitem).wholesale_price).to eq 43.21
          expect(assigns(:consumableitem).term).to eq 18
          expect(assigns(:consumableitem).balance6).to be_within(0.01).of 98.76
          expect(assigns(:consumableitem).consumption1).to eq 8
          expect(assigns(:consumableitem).consumption2).to eq 7
          expect(assigns(:consumableitem).consumption3).to eq 6
          expect(assigns(:consumableitem).consumption4).to eq 5
          expect(assigns(:consumableitem).consumption5).to eq 4
          expect(assigns(:consumableitem).consumption6).to eq 3
          expect(assigns(:consumableitem).contractitem_id).to eq @instance.contractitem_id
        end

        it "returns the correct json" do
          post :manage, @params
          expect(response.body).to be_json_eql({ record: { amount: 71,
                                                           balance6: "98.76",
                                                           consumption1: 8,
                                                           consumption2: 7,
                                                           consumption3: 6,
                                                           consumption4: 5,
                                                           consumption5: 4,
                                                           consumption6: 3,
                                                           contract_type: "different",
                                                           contractitem_id: @instance.contractitem_id,
                                                           description_de: "schon wieder eine Beschreibung",
                                                           description_en: "yet another description",
                                                           position: 87,
                                                           product_line: "cool",
                                                           product_number: "different product number",
                                                           term: 18,
                                                           wholesale_price: "43.21" },
                                                 status: "success"} .to_json)
        end
      end
    end


    describe "DELETE #delete" do
      before :each do
        @instance.update(consumption1: 0,
                         consumption2: 0,
                         consumption3: 0,
                         consumption4: 0,
                         consumption5: 0,
                         consumption6: 0)
      end

      it "finds the right consumableitem" do
        post :delete, id: @instance.id
        expect(assigns(:consumableitem)).to eql @instance
      end

      it "deletes the consumableitem" do
        post :delete, id: @instance.id
        expect(Consumableitem.where(id: @instance.id)).to be_empty
      end

      it "renders nothing" do
        post :delete, id: @instance.id
        expect(response.body).to eql(" ")
      end

      it "blocks deletetion, if there are consumableitemitems" do
        @instance.update(consumption1: 1)

        post :delete, id: @instance.id
        expect(Consumableitem.find(@instance.id)).to eql @instance
      end
    end


    describe "GET #defaults" do
      it "returns the correct json" do
        create(:consumableitem, contractitem_id: @contractitem.id)

        get :defaults, id: @contractitem.id, format: :text
        expect(response.body).to be_json_eql( { vendor_number: "HP-TR0815",
                                                wholesale_price: "42.15" }.to_json)
      end
    end
  end
end