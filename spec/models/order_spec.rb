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


    context "discount" do
      it "returns discount if any" do
        expect(@order.discount).to eql 1.2
      end

      it "returns 0 discount if nono given" do
        @order.update(discount_rel: 0)
        expect(@order.discount).to eql 0
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

    it "adds up amounts without inventories" do
      @order.merge(basket: @second_order)
      @lineitem.reload
      expect(@lineitem.amount).to eql 7
    end

    it "adds up amounts with inventories" do
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


  context "billing_address_filled?" do
    before :each do
      @order = create(:order)
    end

    it "returns true if all billing data filled" do
      expect(@order.billing_address_filled?).to eql true
    end

    it "returns false if surname missing" do
      @order.update(billing_surname: nil)
      expect(@order.billing_address_filled?).to eql false
    end

    it "returns false if street missing" do
      @order.update(billing_street: nil)
      expect(@order.billing_address_filled?).to eql false
    end

    it "returns false if postalcode missing" do
      @order.update(billing_postalcode: nil)
      expect(@order.billing_address_filled?).to eql false
    end

    it "returns false if city missing" do
        @order.update(billing_city: nil)
      expect(@order.billing_address_filled?).to eql false
    end

    it "returns false if country missing" do
        @order.update(billing_country: nil)
      expect(@order.billing_address_filled?).to eql false
    end
  end


  context "add_shipment_costs" do
    before :each do
      @user = create(:user)
      @order = create(:order, user: @user)
      allow(@order).to receive(:acting_user) { @user }

      create(:constant_shipping_cost)
      @product_versandspesen = create(:shipping_cost_article)
    end

    context "with mesonic" do
      before :each do
        @erp_constant = Rails.application.config.erp # store it, to be able to ....
        Rails.application.config.erp = "mesonic"

        @order.add_shipment_costs
        @shipping_cost_lineitem = @order.lineitems.first
      end

      after :each do
        Rails.application.config.erp = @erp_constant # ... restore it
      end

      it "creates shipping cost lineitem" do
        expect{@order.add_shipment_costs}.to change {@order.lineitems.count}.by 1
      end

      it "has user_id set" do
        expect(@shipping_cost_lineitem.user_id).to eql @user.id
      end

      it "has position set" do
        expect(@shipping_cost_lineitem.position).to eql 10000
      end

      it "has product_number set" do
        expect(@shipping_cost_lineitem.product_number).to eql "VERSANDSPESEN"
      end

      it "has description_de set" do
        expect(@shipping_cost_lineitem.description_de).to eql "Versandkostenanteil"
      end

      it "has description_en set" do
        expect(@shipping_cost_lineitem.description_en).to eql "Shipping Costs"
      end

      it "has amount set" do
        expect(@shipping_cost_lineitem.amount).to eql 1
      end

      it "has unit set" do
        expect(@shipping_cost_lineitem.unit).to eql "Pau."
      end

      it "has vat set" do
        expect(@shipping_cost_lineitem.vat).to eql 20
      end

      it "has product_price set" do
        expect(@shipping_cost_lineitem.product_price).to eql 12
      end

      it "has value set" do
        expect(@shipping_cost_lineitem.value).to eql 12
      end

      it "has product_id set" do
        expect(@shipping_cost_lineitem.product_id).to eql @product_versandspesen.id
      end
    end

    context "without mesonic" do
      before :each do
        @shipping_cost = create(:shipping_cost)
        @erp_constant = Rails.application.config.erp # store it, to be able to ....
        Rails.application.config.erp = "no mesonic!"
        @order.add_shipment_costs
        @shipping_cost_lineitem = @order.lineitems.first
      end

      after :each do
        Rails.application.config.erp = @erp_constant # ... restore it
      end

      it "creates shipping cost lineitem" do
        expect{@order.add_shipment_costs}.to change {@order.lineitems.count}.by 1
      end

      it "has user_id set" do
        expect(@shipping_cost_lineitem.user_id).to eql @user.id
      end

      it "has position set" do
        expect(@shipping_cost_lineitem.position).to eql 10000
      end

      it "has product_number set" do
        expect(@shipping_cost_lineitem.product_number).to eql "VERSANDSPESEN"
      end

      it "has description_de set" do
        expect(@shipping_cost_lineitem.description_de).to eql "Versandkostenanteil"
      end

      it "has description_en set" do
        expect(@shipping_cost_lineitem.description_en).to eql "Shipping Costs"
      end

      it "has amount set" do
        expect(@shipping_cost_lineitem.amount).to eql 1
      end

      it "has unit set" do
        expect(@shipping_cost_lineitem.unit).to eql "Pau."
      end

      it "has vat set" do
        expect(@shipping_cost_lineitem.vat).to eql @shipping_cost.vat
      end

      it "has product_price set" do
        expect(@shipping_cost_lineitem.product_price).to eql @shipping_cost.value
      end

      it "has value set" do
        expect(@shipping_cost_lineitem.value).to eql @shipping_cost.value
      end

      it "has product_id set" do
        expect(@shipping_cost_lineitem.product_id).to eql nil
      end
    end
  end


  context "shipping_cost derivation methods" do
    before :each do
      @user = create(:user)
      @order = create(:order, user: @user)
      allow(@order).to receive(:acting_user) { @user }

      create(:constant_shipping_cost)
      @product_versandspesen = create(:shipping_cost_article)

      @order.add_shipment_costs
      @shipping_cost_lineitem = @order.lineitems.first
    end

    context "shipping_cost" do
      it "returns shipping costs" do
        expect(@order.shipping_cost).to eql @shipping_cost_lineitem.value
      end
    end

    context "shipping_cost_vat" do
      it "returns shipping cost vat" do
        expect(@order.shipping_cost_vat).to eql @shipping_cost_lineitem.vat
      end
    end
  end


  context "delete_if_obsolete" do
    before :each do
      @user = create(:user)
      @admin = create(:admin)
      @order = create(:order, user: @admin)
      allow(@order).to receive(:acting_user) { @admin }
      create(:constant_shipping_cost)
      create(:shipping_cost_article)
    end

    it "deletes order if no lineitem" do
      expect{@order.delete_if_obsolete}.to change {Order.count}.by -1
    end

    it "deletes order if only lineitem is shipping costs" do
      @order.add_shipment_costs
      expect{@order.delete_if_obsolete}.to change {Order.count}.by -1
    end

    it "does not delete item with regular lineitem" do
      create(:lineitem, order: @order)
      expect{@order.delete_if_obsolete}.to_not change {Order.count}
    end
  end


  # --- Class Methods --- #

  context "cleanup_deprecated" do
    it "doesn't touch new baskets" do
      create(:order)
      expect{Order.cleanup_deprecated}.not_to change{Order.count}
    end

    it "deletes_if_obsolete for baskets older than one hour" do
      @order = create(:order)
      @order.update(created_at: Time.now - 2.hours) # we fake the creation date
      expect{Order.cleanup_deprecated}.to change{Order.count}.by -1
    end
  end


  context "notify_in_payment" do
    it "sends emails for orders in status in payment not older than 1 day" do
      create(:constant_service_mail)
      create(:mail_subject)
      @order = create(:order, state: "in_payment", updated_at: Time.now - 2.hours)
      expect(OrderMailer).to receive(:notify_in_payment).and_return( double("OrderMailer", :deliver => true))
      Order.notify_in_payment
    end
  end
end