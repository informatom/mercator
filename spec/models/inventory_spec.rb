require 'spec_helper'

describe Inventory do
  it "is valid with name_de, name_en, number, amount, unit,
                    comment_de, comment_en, weight, charge, storage, delivery_time,
                    erp_updated_at, erp_vatline, erp_article_group, erp_provision_code,
                    erp_characteristic_flag, infinite, just_imported, alternative_number" do
    expect(build :inventory).to be_valid
  end

  it {should validate_presence_of :name_de}
  it {should validate_presence_of :number}
  it {should validate_presence_of :amount}
  it {should validate_presence_of :unit}
  it {should validate_numericality_of :amount}
  it {should validate_numericality_of :weight}

  it {should belong_to :product}
  it {should validate_presence_of :product}
  it {should have_many :prices}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

  it "has a photo attached" do
    is_expected.to respond_to :photo
  end


  #--- Instance methods ---#

  context "determine_price" do
    before :each do
      @inventory_with_two_prices = create(:inventory_with_two_prices)
      @user = create(:user)
    end

    it "determines the user specific price excl vat" do
      expect(@inventory_with_two_prices.determine_price(customer_id: @user.id)).to eql(42)
    end

    it "determines the user specific price incl vat" do
      expect(@inventory_with_two_prices.determine_price(customer_id: @user.id,
                                                        incl_vat: true)).to eql(50.4)
    end

    it "determines the user specific reduced price per item for a higher amount" do
      expect(@inventory_with_two_prices.determine_price(customer_id: @user.id,
                                                        amount: 7)).to eql(38)
    end
  end

  context "select_price" do
    it "determines the price" do
      @price = create(:price)
      @inventory = @price.inventory
      expect(@inventory.select_price).to eql(@price)
    end
  end

  context "determine_vat" do
    it "determines the vat" do
      @price = create(:price)
      @inventory = @price.inventory
      expect(@inventory.determine_vat).to eql(@price.vat)
    end
  end

  context "selectortext" do
    it "return the selectortext" do
      @inventory = create(:inventory)
      expect(@inventory.selectortext).to eql("Size: 42 / Domgasse")
    end
  end


  #--- Class methods ---#

  context "delete_orphans" do
    it "deletes orphan" do
      create(:inventory)
      expect{Inventory.delete_orphans}.to change{Inventory.count}.by(-1)
    end

    it "leaves not orphaned inventory untouched" do
      create(:price)
      expect{Inventory.delete_orphans}.not_to change{Inventory.count}
    end
  end
end