require 'spec_helper'

describe Order do
  it "is valid with billing_method, billing_gender, billing_title, billing_first_name," +
     "billing_surname, billing_company, billing_detail, billing_street, billing_postalcode, " +
     "billing_city, billing_country, billing_phone, shipping_method, shipping_gender, " +
     "shipping_first_name, shipping_surname, shipping_company, shipping_detail, shipping_street," +
     "shipping_postalcode, shipping_city, shipping_country, shipping_phone, store, gtc_confirmed_at," +
     "gtc_version_of, erp_customer_number, erp_billing_number, erp_order_number, discount_rel" do
    expect(build :order).to be_valid
  end

  it {should belong_to :user}
  it {should validate_presence_of :user}

  it {should have_many :lineitems}
  it {should belong_to :conversation}

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  # --- Instance Methods --- #

  context "basket?" do
    it "returns true for basket" do
      @order = create(:order, state: "basket")
      expect(@order.basket?).to eql(true)
    end

    it "it returns false, if no basket" do
      @order = create(:order, state: "ordered")
      expect(@order.basket?).to eql(false)
    end
  end


  context "shippable?" do
    it "returns true if all lineitems are shippable" do
      @order = create(:order)
      @lineitem = create(:lineitem, order: @order)
      expect(@order.shippable?).to eql(true)
    end

    it "returns false if at least one lineitems is not shippable" do
      @order = create(:order)
      @product = create(:product, not_shippable: true)
      @lineitem = create(:lineitem, order: @order,
                                    product: @product)
      expect(@order.shippable?).to eql(false)
    end
  end


  context "accepted_offer?" do
    it "returns true for accepted_offer" do
      @order = create(:order, state: "accepted_offer")
      expect(@order.accepted_offer?).to eql(true)
    end

    it "it returns false, if no accepted_offer" do
      @order = create(:order, state: "ordered")
      expect(@order.accepted_offer?).to eql(false)
    end
  end


  context "order calculations" do
    before :each do
      @order = create(:order, discount_rel: 10)
      @product = create(:product)
      create(:lineitem, order: @order, value: 5, product: @product)
      create(:lineitem, order: @order, value: 7, product: @product)
    end

    context "sum" do
      it "returns sum of order" do
        expect(@order.sum).to eql(10.8)
      end
    end


    context "vat" do
      it "returns vat of order" do
        expect(@order.vat).to eql(2.16)
      end
    end


    context "sum_incl_vat" do
      it "returns sum including vat of order" do
        expect(@order.sum_incl_vat).to eql(12.96)
      end
    end


    context "vat_items" do
      it "returns hash of vat items" do
        create(:lineitem, order: @order, value: 7, product: @product, vat: 10)
        expect(@order.vat_items).to eql({BigDecimal.new("10") => BigDecimal.new("0.63"),
                                         BigDecimal.new("20") => BigDecimal.new("2.16")})
      end
    end


    context "name" do
      it "returns name for basket" do
        expect(@order.name).to include("Basket from")
      end

      it "returns name for accepted offer" do
        @order.state = "accepted_offer"
        expect(@order.name).to include("Order from")
      end
    end
  end


  context "add_product" do
    before :each do
      @order = create(:order)
      @product = create(:product_with_inventory_and_two_prices)
    end

    it "adds a lineitem to the basket, if there has not been any for that product" do
      expect{@order.add_product(product: @product)}.to change{@order.lineitems.count}.by(1)
    end

    it "creates a lineitem with the correct amount" do
      @order.add_product(product: @product,
                         amount: 5)
      @order.reload
      expect(@order.lineitems.first.amount).to eql 5
    end

    it "increases the amount for the correct lineitem if there was already a lineitem for the product" do
      @lineitem = create(:lineitem, order: @order,
                                    product: @product,
                                    amount: 4)
      @order.add_product(product: @product)
      @lineitem.reload
      expect(@lineitem.amount).to eql 5
    end

    it "increases by the correct amount" do
      @lineitem = create(:lineitem, product: @product,
                                    order: @order,
                                    amount: 4)
      @order.add_product(product: @product,
                                amount: 5)
      @lineitem.reload
      expect(@lineitem.amount).to eql 9
    end
  end


  context "add_inventory" do
    before :each do
      @order = create(:order)
      @product = create(:product)
      @inventory = create(:inventory_with_two_prices, product: @product)
    end

    it "adds a lineitem to the basket, if there has not been any for that inventory" do
      expect{@order.add_inventory(inventory: @inventory)}.to change{@order.lineitems.count}.by(1)
    end

    it "creates a lineitem with the correct amount" do
      @order.add_inventory(inventory: @inventory,
                           amount: 5)
      @order.reload
      expect(@order.lineitems.first.amount).to eql 5
    end

    it "increases the amount for the correct lineitem if there was already a lineitem for the inventory" do
      @lineitem = create(:lineitem, order: @order,
                                    inventory: @inventory,
                                    product: @product,
                                    amount: 4)
      @order.add_inventory(inventory: @inventory)
      @lineitem.reload
      expect(@lineitem.amount).to eql 5
    end

    it "increases by the correct amount" do
      @lineitem = create(:lineitem, inventory: @inventory,
                                    order: @order,
                                    product: @product,
                                    amount: 4)
      @order.add_inventory(inventory: @inventory,
                           amount: 5)
      @lineitem.reload
      expect(@lineitem.amount).to eql 9
    end
  end


  context "merge" do
    before :each do
      @user = create(:user)
      @order = create(:order, gtc_version_of: Date.new(2014,1,1),
                              user: @user)
      @product = create(:product)
      @second_product = create(:second_product)

      @inventory = create(:inventory_with_two_prices, product: @product)
      @lineitem = create(:lineitem, product: @product,
                                    order: @order,
                                    amount: 3)
      @fourth_lineitem = create(:lineitem, inventory: @inventory,
                                           product: @product,
                                           order: @order,
                                           amount: 7)

      @second_order = create(:order, gtc_version_of: Date.new(2014,5,1),
                                     user: @user)
      @second_lineitem = create(:lineitem, product: @product,
                                           order: @second_order,
                                           amount: 4)
      @third_lineitem = create(:lineitem, product: @second_product,
                                          order: @second_order,
                                          amount: 4)
      @fifth_lineitem = create(:lineitem, inventory: @inventory,
                                          product: @product,
                                          order: @second_order,
                                          amount: 11)
    end

    it "merges two baskets into one" do
      expect{@order.merge(basket: @second_order)}.to change {Order.count}.by(-1)
    end

    it "adds up amounts without inventories correctly" do
      @order.merge(basket: @second_order)
      @lineitem.reload
      expect(@lineitem.amount).to eql 7
    end

    it "adds up amounts with inventories correctly" do
      @order.merge(basket: @second_order)
      @fourth_lineitem.reload
      expect(@fourth_lineitem.amount).to eql 18
    end

    it "moves lineitems, that are new" do
      @order.merge(basket: @second_order)
      @third_lineitem.reload
      expect(@third_lineitem.order).to eql(@order)
    end

    it "updates gtc_version to later one" do
      @order.merge(basket: @second_order)
      @order.reload
      expect(@order.gtc_version_of).to eql(Date.new(2014,5,1))
    end

    it "returns 'merged'" do
      expect(@order.merge(basket: @second_order)).to eql "merged"
    end
  end

  # --- Class Methods --- #
end