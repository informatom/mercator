require 'spec_helper'

describe Order do
  before :each do
    create(:country)
    create(:constant_service_mail)
    create(:constant_order_confirmation_mail_subject)

    # for kontenstamm_fakt => belegart derivation
    @user = create(:user, erp_account_nr: "1I20533-2004-1380",
                          erp_contact_nr: "8272-2004-1380")

    @order = create(:order, user_id: @user.id)
    @product = create(:product_with_inventory_and_lower_price)
    @lineitem = create(:lineitem, order_id: @order.id,
                                  user_id: @user.id,
                                  product_id: @product.id)
  end

  # --- Instance Methods --- #

  describe "mesonic_payment_id" do
    it "returns 1002 for cash payment" do
      @order.update(billing_method: "cash_payment")
      expect(@order.mesonic_payment_id).to eql "1002"
    end

    it "returns 1003 for atm_payment" do
      @order.update(billing_method: "atm_payment")
      expect(@order.mesonic_payment_id).to eql "1003"
    end

    it "returns 1010 for pre_payment" do
      @order.update(billing_method: "pre_payment")
      expect(@order.mesonic_payment_id).to eql "1010"
    end

    it "returns 1011 for epayment" do
      @order.update(billing_method: "e_payment")
      expect(@order.mesonic_payment_id).to eql "1011"
    end
  end


  describe "mesonic_payment_id2" do
    it "returns 17 for cash payment" do
      @order.update(billing_method: "cash_payment")
      expect(@order.mesonic_payment_id2).to eql "17"
    end

    it "returns 17 for atm_payment" do
      @order.update(billing_method: "atm_payment")
      expect(@order.mesonic_payment_id2).to eql "17"
    end

    it "returns 19 for pre_payment" do
      @order.update(billing_method: "pre_payment")
      expect(@order.mesonic_payment_id2).to eql "19"
    end

    it "returns 25 for epayment" do
      @order.update(billing_method: "e_payment")
      expect(@order.mesonic_payment_id2).to eql "25"
    end
  end



  describe "mesonic_shipping_id" do
    it "returns 17 for parcel_service_shipment" do
      @order.update(shipping_method: "parcel_service_shipment")
      expect(@order.mesonic_shipping_id).to eql "1"
    end

    it "returns 17 for pickup_shipment" do
      @order.update(shipping_method: "pickup_shipment")
      expect(@order.mesonic_shipping_id).to eql "2"
    end
  end


  describe "push_to_mesonic" do
    before :each do
      @order.instance_variable_set("@save_return_value", true)
    end

    it "creates a mesonic order" do
      @order.push_to_mesonic
      expect(@order.instance_variable_get(:@mesonic_order)).to be_a MercatorMesonic::Order
    end

    it "sets the attributes in the order" do
      @order.push_to_mesonic
      @mesonic_order = @order.instance_variable_get(:@mesonic_order)
      expect(@mesonic_order.c008).to eql "Musterstadt"
      # The other attributes need not to be checked, we just want to see if the order is transfered
    end

    it "creates a mesonic order item" do
      @order.push_to_mesonic
      expect(@order.instance_variable_get(:@mesonic_order_items).first).to be_a MercatorMesonic::OrderItem
    end

    it "sets the attributes in the order" do
      @order.push_to_mesonic
      @mesonic_order_item = @order.instance_variable_get(:@mesonic_order_items).first
      expect(@mesonic_order_item.c004).to eql "default product"
      # The other attributes need not to be checked, we just want to see if the order item is transfered
    end

    it "updates some attributes" do
      @order.push_to_mesonic
      expect(@order.erp_customer_number).to eql "1I20533-2004-1380"
      expect(@order.erp_billing_number).to eql "09WEB"
      expect(@order.erp_order_number.length > 16).to eql true
    end

    it "sends the order confirmatation" do
      expect(OrderMailer).to receive_message_chain(:confirmation, :deliver)
      @order.push_to_mesonic
    end
  end
end