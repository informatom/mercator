require 'spec_helper'

describe Inventory do
  it "has many mesonic_prices" do
    it {should have_many :mesonic_prices}
  end

  # --- Instance Methods --- #

  describe "mesonic_price" do
    before :each do
      @user = create(:user)
      @inventory = create(:inventory)
    end

    it "finds the customer" do
      @inventory.mesonic_price(customer_id: @user.id)
      expect(@inventory.instance_variable_get(:@customer)).to eql @user
    end

    it "searches for the price" do
      expect(@inventory).to receive_message_chain(:mesonic_prices, :by_customer)
      @inventory.mesonic_price(customer_id: @user.id)
    end

    it "returns no price, if nothing found" do
      expect(@inventory.mesonic_price(customer_id: @user.id)).to eql nil
    end

    it "returns the price, if found" do
      @user.update(erp_account_nr: "661016")
      @inventory.update(number: "HP-Q2676A")
      expect(@inventory.mesonic_price(customer_id: @user.id)).to eql 213.33
    end

    it "calculates the netto price, if gross prices are to be imported" do
      create(:constant, key: "import_gross_prices_from_erp",
                        value: "true")
      create(:price, inventory_id: @inventory.id)
      @user.update(erp_account_nr: "661016")
      @inventory.update(number: "HP-Q2676A")

      expect(@inventory.mesonic_price(customer_id: @user.id)).to eql 177.775
    end
  end
end