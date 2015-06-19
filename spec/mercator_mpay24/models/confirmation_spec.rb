require 'spec_helper'

describe MercatorMpay24::Confirmation do
  it "is valid with payment, operation, tid, status, price, currency, p_type, brand, mpaytid," +
     "user_field, orderdesc, customer, customer_email, language, customer_id, profile_id," +
     "profile_status, filter_status and appr_code " do
    expect(build :confirmation).to be_valid
  end

  it {should belong_to :payment}

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  # --- Instance Methods --- #

  describe "update_order" do
    before :each do
      @user = create(:user)
      @order = create(:order, state: "in_payment",
                              user_id: @user.id)
      @payment = create(:payment, order_id: @order.id)
      @confirmation = create(:confirmation, payment_id: @payment.id)
      create(:mpay24_user)
    end

    it "updates the order state to failed payment if status ERROR" do
      @confirmation.update(status: "ERROR")
      @confirmation.update_order
      expect(@confirmation.payment.order.state).to eql "payment_failed"
    end

    it "updates the order state to failed payment if status REVERSED" do
      @confirmation.update(status: "REVERSED")
      @confirmation.update_order
      expect(@confirmation.payment.order.state).to eql "payment_failed"
    end

    it "updates the order state to failed payment if status CREDITED" do
      @confirmation.update(status: "CREDITED")
      @confirmation.update_order
      expect(@confirmation.payment.order.state).to eql "payment_failed"
    end

    it "doesn't update the order state if status RESERVED" do
      @confirmation.update(status: "RESERVED")
      @confirmation.update_order
      expect(@confirmation.payment.order.state).to eql "in_payment"
    end

    it "doesn't update the order state if status SUSPENDED" do
      @confirmation.update(status: "SUSPENDED")
      @confirmation.update_order
      expect(@confirmation.payment.order.state).to eql "in_payment"
    end

    context "BILLED" do
      it "updates the order state to failed payment if status BILLED but wrong user field hash" do
        @confirmation.update(status: "BILLED")
        @confirmation.update_order
        expect(@confirmation.payment.order.state).to eql "payment_failed"
      end

      it "updates the order state to paid if status BILLED" do
        @payment.update(user_field_hash: "219ff7718187c30ae3f41f05715c9dac0e1f075f25cc9782ed4...")
        @confirmation.update(status: "BILLED")
        @confirmation.update_order
        expect(@confirmation.payment.order.state).to eql "paid"
      end

      it "updates erp account nr" do
        @payment.update(user_field_hash: "219ff7718187c30ae3f41f05715c9dac0e1f075f25cc9782ed4...")
        @confirmation.update(status: "BILLED")
        @confirmation.update_order

        allow(Rails).to receive(:env) { "production" }
        expect(@confirmation.payment.order.user).to receive(:update_erp_account_nr).and_return(true)
        allow(@confirmation.payment.order).to receive(:push_to_mesonic).and_return(true)
        @confirmation.update_order
      end

      it "pushes to mesonic" do
        @payment.update(user_field_hash: "219ff7718187c30ae3f41f05715c9dac0e1f075f25cc9782ed4...")
        @confirmation.update(status: "BILLED")
        @confirmation.update_order

        allow(Rails).to receive(:env) { "production" }
        allow(@confirmation.payment.order.user).to receive(:update_erp_account_nr).and_return(true)
        expect(@confirmation.payment.order).to receive(:push_to_mesonic).and_return(true)
        @confirmation.update_order
      end
    end
  end
end