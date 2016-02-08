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
        expect(response.body).to be_json_eql( {records: [{ amount: 1,
                                                           balance1: 0,
                                                           balance2: 42.0,
                                                           balance3: -26.000000000000004,
                                                           balance4: 14.000000000000004,
                                                           balance5: 13.999999999999993,
                                                           consumption1: 3,
                                                           consumption2: 4,
                                                           consumption3: 5,
                                                           consumption4: 6,
                                                           consumption5: 7,
                                                           contract_type: "standard",
                                                           monthly_rate1: 0,
                                                           monthly_rate2: 2.0,
                                                           monthly_rate3: 8.0,
                                                           monthly_rate4: 5.833333333333333,
                                                           monthly_rate5: 7.0,
                                                           position: 1,
                                                           price: 14,
                                                           product_line: "shiny",
                                                           product_number: "123",
                                                           product_title: "ein Verbrauchsmaterial",
                                                           recid: @instance.id,
                                                           theyield: 12000,
                                                           value: 14,
                                                           wholesale_price1: "12.5",
                                                           wholesale_price2: "12.5",
                                                           wholesale_price3: "12.5",
                                                           wholesale_price4: "12.5",
                                                           wholesale_price5: "12.5" },
                                                         { amount: 2,
                                                           balance1: 0,
                                                           balance2: 20.0,
                                                           balance3: -42.42857142857143,
                                                           balance4: -13.000000000000002,
                                                           balance5: -14.0,
                                                           consumption1: 5,
                                                           consumption2: 4,
                                                           consumption3: 3,
                                                           consumption4: 2,
                                                           consumption5: 1,
                                                           contract_type: "alternative",
                                                           monthly_rate1: 0,
                                                           monthly_rate2: 2.857142857142857,
                                                           monthly_rate3: 6.285714285714286,
                                                           monthly_rate4: 3.25,
                                                           monthly_rate5: 2.3333333333333335,
                                                           position: 2,
                                                           price: 9,
                                                           product_line: "brass",
                                                           product_number: "another product number",
                                                           product_title: "ein anderes Verbrauchsmaterial",
                                                           recid: @second_consumableitem.id,
                                                           theyield: 1200,
                                                           value: 18,
                                                           wholesale_price1: "8.0",
                                                           wholesale_price2: "9.0",
                                                           wholesale_price3: "10.0",
                                                           wholesale_price4: "11.0",
                                                           wholesale_price5: "12.0" } ],
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
                               product_title: "a product title",
                               product_line: "cool",
                               theyield: 7777,
                               amount: 71,
                               wholesale_price1: 43.21,
                               wholesale_price2: 42.21,
                               wholesale_price3: 41.21,
                               wholesale_price4: 40.21,
                               wholesale_price5: 39.21,
                               consumption1: 8,
                               consumption2: 7,
                               consumption3: 6,
                               consumption4: 5,
                               consumption5: 4,
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
          expect(assigns(:consumableitem).product_title).to eq "a product title"
          expect(assigns(:consumableitem).product_line).to eq "cool"
          expect(assigns(:consumableitem).theyield).to eq 7777
          expect(assigns(:consumableitem).amount).to eq 71
          expect(assigns(:consumableitem).wholesale_price1).to eq 43.21
          expect(assigns(:consumableitem).wholesale_price2).to eq 42.21
          expect(assigns(:consumableitem).wholesale_price3).to eq 41.21
          expect(assigns(:consumableitem).wholesale_price4).to eq 40.21
          expect(assigns(:consumableitem).wholesale_price5).to eq 39.21
          expect(assigns(:consumableitem).consumption1).to eq 8
          expect(assigns(:consumableitem).consumption2).to eq 7
          expect(assigns(:consumableitem).consumption3).to eq 6
          expect(assigns(:consumableitem).consumption4).to eq 5
          expect(assigns(:consumableitem).consumption5).to eq 4
          expect(assigns(:consumableitem).contractitem_id).to eq @instance.contractitem_id
        end

        it "returns the correct json" do
          post :manage, @params
          expect(response.body).to be_json_eql({ record: { amount: 71,
                                                           consumption1: 8,
                                                           consumption2: 7,
                                                           consumption3: 6,
                                                           consumption4: 5,
                                                           consumption5: 4,
                                                           contract_type: "different",
                                                           contractitem_id: @instance.contractitem_id,
                                                           theyield: 7777,
                                                           position: 87,
                                                           product_line: "cool",
                                                           product_number: "different product number",
                                                           product_title: "a product title",
                                                           wholesale_price1: "43.21",
                                                           wholesale_price2: "42.21",
                                                           wholesale_price3: "41.21",
                                                           wholesale_price4: "40.21",
                                                           wholesale_price5: "39.21" },
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
                         consumption5: 0)
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
        expect(response.body).to eql("")
      end

      it "blocks deletetion, if there are consumableitemitems" do
        @instance.update(consumption1: 1)

        post :delete, id: @instance.id
        expect(Consumableitem.find(@instance.id)).to eql @instance
      end
    end
  end
end