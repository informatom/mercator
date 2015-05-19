require 'spec_helper'

describe Lineitem do
  it "is valid with position, product_number, product, description_de,
     description_en, amount, unit, product_price, vat and value,
     upselling, discountyvabs" do
    expect(build :lineitem).to be_valid
  end

  it "can be a manually created item" do
    expect(build :manual_lineitem).to be_valid
  end

  it {should validate_presence_of :product_number}
  it {should validate_presence_of :position}
  it {should validate_presence_of :description_de}
  it {should validate_presence_of :amount}
  it {should validate_presence_of :unit}
  it {should validate_presence_of :product_price}
  it {should validate_presence_of :vat}
  it {should validate_presence_of :value}
  it {should validate_presence_of :discount_abs}

  it {should validate_numericality_of :amount}
  it {should validate_numericality_of :discount_abs}
  it {should validate_numericality_of :product_price}
  it {should validate_numericality_of :vat}
  it {should validate_numericality_of :value}

  it {should belong_to :order}
  it {should validate_presence_of :order}

  it {should belong_to :user}
  it {should belong_to :product}
  it {should belong_to :inventory}

  it "acts as a list" do
    is_expected.to respond_to :move_to_top
  end

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  # --- Instance Methods --- #

  context "increase_amount" do
    before :each do
      @product = create(:product_with_inventory_and_two_prices)
      @lineitem = create(:lineitem, product: @product)
    end

    it "increases the amount" do
      expect{@lineitem.increase_amount(amount: 5)}.to change{@lineitem.amount}.by 5
    end

    it "runs a new pricing" do
      expect(@lineitem).to receive(:new_pricing)
      @lineitem.increase_amount
    end
  end


  context "new_pricing" do
    before :each do
      @product = create(:product_with_inventory_and_two_prices)
      @lineitem = create(:lineitem, amount: 1,
                                    discount_abs: 0,
                                    product: @product)
    end

    it "sets a product price" do
      @lineitem.new_pricing
      expect(@lineitem.product_price).to eql(42)
    end

    it "calculates a value" do
      @lineitem.new_pricing
      expect(@lineitem.value).to eql(42)
    end

    it "takes amount into consideration for value" do
      @lineitem.amount = 10
      @lineitem.new_pricing
      expect(@lineitem.value).to eql(380)
    end

    it "takes discount into consideration for value" do
      @lineitem.discount_abs = 10
      @lineitem.new_pricing
      expect(@lineitem.value).to eql(32)
    end
  end


  context "merge" do
    before :each do
      @order = create(:order)
      @product = create(:product_with_inventory_and_two_prices)
      @lineitem = create(:lineitem, amount: 3,
                                    product: @product,
                                    order: @order)
      @lineitem_two = create(:lineitem, amount: 4,
                                        product: @product,
                                        order: @order)
    end

    it "merges two lineitems" do
      @lineitem.merge(lineitem: @lineitem_two)
      expect(@lineitem.amount).to eql 7
    end

    it "deletes the second lineitem" do
      @lineitem.merge(lineitem: @lineitem_two)
      expect(@lineitem_two.destroyed?).to be true
    end
  end


  context "vat_value" do
    it "calculates the vat" do
      @lineitem = create(:lineitem)
      expect(@lineitem.vat_value).to eql 1036.98
    end

    it "takes discount_rel into account" do
      @lineitem = create(:lineitem)
      expect(@lineitem.vat_value(discount_rel: 10)).to eql 933.282
    end
  end


  context "value_incl_vat" do
    it "calculates value incl vat" do
      @lineitem = create(:lineitem)
      expect(@lineitem.value_incl_vat).to eql 6221.88
    end
  end


  context "gross_price" do
    it "calculates the gross price" do
      @lineitem = create(:lineitem)
      expect(@lineitem.gross_price).to eql 148.14
    end
  end


  context "undiscounted_gross_value" do
    it "calculates the gross price" do
      @lineitem = create(:lineitem)
      expect(@lineitem.undiscounted_gross_value).to eql 6221.88
    end
  end


  # --- Class Methods --- #

  context "create_from_product" do
    before :each do
      @product = create(:product_with_inventory_and_two_prices)
      @user = create(:user)
      @order = create(:order, user: @user)
    end

    it "creates a new lineitem" do
      expect{Lineitem.create_from_product(product: @product,
                                          user_id: @user.id,
                                          order_id: @order.id,
                                          position: 1)}.to change {Lineitem.count}.by 1
    end

    context "setting attributes" do
      before :each do
        @new_lineitem = Lineitem.create_from_product(product: @product,
                                            user_id: @user.id,
                                            order_id: @order.id,
                                            position: 1,
                                            amount: 7)
      end

      it "sets user_id" do
        expect(@new_lineitem.user_id).to eql @user.id
      end

      it "sets order_id" do
        expect(@new_lineitem.order_id).to eql @order.id
      end

      it "sets position" do
        expect(@new_lineitem.position).to eql 1
      end

      it "sets product_id" do
        expect(@new_lineitem.product_id).to eql @product.id
      end

      it "sets product_number" do
        expect(@new_lineitem.product_number).to eql @product.number
      end

      it "sets description_de" do
        expect(@new_lineitem.description_de).to eql @product.title_de
      end

      it "sets description_en" do
        expect(@new_lineitem.description_en).to eql @product.title_en
      end

      it "sets delivery_time" do
        expect(@new_lineitem.delivery_time).to eql @product.delivery_time
      end

      it "sets amount" do
        expect(@new_lineitem.amount).to eql 7
      end

      it "sets unit" do
        expect(@new_lineitem.unit).to eql @product.inventories.first.unit
      end

      it "sets product_price" do
        expect(@new_lineitem.product_price).to eql 38
      end

      it "sets value" do
        expect(@new_lineitem.value).to eql(7 * 38)
      end

      it "sets vat" do
        expect(@new_lineitem.vat).to eql 20
      end
    end

    it "runs a new pricing procedure" do
      expect_any_instance_of(Lineitem).to receive(:new_pricing)
      Lineitem.create_from_product(product: @product,
                                   user_id: @user.id,
                                   order_id: @order.id,
                                   position: 1)
    end
  end


  context "create_from_inventory" do
    before :each do
      @inventory = create(:inventory_with_two_prices)
      @user = create(:user)
      @order = create(:order, user: @user)
    end

    it "creates a new lineitem" do
      expect{Lineitem.create_from_inventory(inventory: @inventory,
                                            user_id: @user.id,
                                            order_id: @order.id,
                                            position: 1)}.to change {Lineitem.count}.by 1
    end

    context "setting attributes" do
      before :each do
        @new_lineitem = Lineitem.create_from_inventory(inventory: @inventory,
                                                       user_id: @user.id,
                                                       order_id: @order.id,
                                                       position: 1,
                                                       amount: 7)
      end

      it "sets user_id" do
        expect(@new_lineitem.user_id).to eql @user.id
      end

      it "sets order_id" do
        expect(@new_lineitem.order_id).to eql @order.id
      end

      it "sets position" do
        expect(@new_lineitem.position).to eql 1
      end

      it "sets product_id" do
        expect(@new_lineitem.product_id).to eql @inventory.product.id
      end

      it "sets inventory_id" do
        expect(@new_lineitem.inventory_id).to eql @inventory.id
      end

      it "sets product_number" do
        expect(@new_lineitem.product_number).to eql @inventory.number
      end

      it "sets description_de" do
        expect(@new_lineitem.description_de).to eql @inventory.product.title_de
      end

      it "sets description_en" do
        expect(@new_lineitem.description_en).to eql @inventory.product.title_en
      end

      it "sets delivery_time" do
        expect(@new_lineitem.delivery_time).to eql @inventory.delivery_time
      end

      it "sets amount" do
        expect(@new_lineitem.amount).to eql 7
      end

      it "sets unit" do
        expect(@new_lineitem.unit).to eql @inventory.unit
      end

      it "sets product_price" do
        expect(@new_lineitem.product_price).to eql 38
      end

      it "sets value" do
        expect(@new_lineitem.value).to eql(7 * 38)
      end

      it "sets vat" do
        expect(@new_lineitem.vat).to eql 20
      end
    end

    it "runs a new pricing procedure" do
      expect_any_instance_of(Lineitem).to receive(:new_pricing)
      Lineitem.create_from_inventory(inventory: @inventory,
                                     user_id: @user.id,
                                     order_id: @order.id,
                                     position: 1)
    end
  end


  context "cleanup_orphaned" do
    it "deletes orphans" do
      @lineitem = create(:lineitem)
      @lineitem.update_attribute(:order_id, nil)
      @lineitem.update_attribute(:user_id, nil) # we have to force it ....
      expect{Lineitem.cleanup_orphaned}.to change{Lineitem.count}.by -1
    end

    it "doesn't delete lineitems with orders" do
      @lineitem = create(:lineitem)
      expect{Lineitem.cleanup_orphaned}.not_to change{Lineitem.count}
    end
  end
end