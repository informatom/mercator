require 'spec_helper'

describe MercatorMpay24::Payment do
  it "is valid with merchant_id, tid, user_field_hash, order_xml, order" do
    expect(build :payment).to be_valid
  end

  it {should belong_to :order}
  it {should have_many :confirmations}

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  # --- Instance Methods --- #

  describe "check_transaction_status" do
    context "error response" do
      before :each do
        response = instance_double(Savon::Response, :body => Hash.new(location:    "http://www.informatom.com",
                                                                      status:      "ERROR",
                                                                      return_code: "some return code" ))
        allow(Order::MPAY_TEST_CLIENT).to receive(:call) { response }
        @payment = create(:payment)
      end

      it "creates a new confirmation" do
        @payment.check_transaction_status
        expect(@payment.confirmations.first).to be_a MercatorMpay24::Confirmation
      end

      it "assigns the attributes in error case" do
        @payment.check_transaction_status
        expect(@payment.confirmations.first.payment_id).to eql @payment.id
        expect(@payment.confirmations.first.status).to eql "some return code"
      end
    end


    context "error response" do
      before :each do
        response = instance_double(Savon::Response,
          :body => Hash.new(location: "http://www.informatom.com",
                            status: "BILLED",
                            parameter: [ { name: "STATUS", value: "BILLED" },
                                         { name: "OPERATION", value: "CONFIRMATION" },
                                         { name: "TID", value: "50" },
                                         { name: "PRICE", value: "101520" },
                                         { name: "CURRENCY", value: "EUR" },
                                         { name: "P_TYPE", value: "CC" },
                                         { name: "BRAND", value: "VISA" },
                                         { name: "MPAYTID", value: "1793508" },
                                         { name: "USER_FIELD", value: "219ff7718187c30ae3f41f05715c9dac0e1f075f25cc9782ed4..." },
                                         { name: "ORDERDESC", value: "Warenkorb vom Mo, 9.Feb 15,  9:17" },
                                         { name: "CUSTOMER", value: "50" },
                                         { name: "CUSTOMER_EMAIL", value: "customer@email.com" },
                                         { name: "LANGUAGE", value: "DE" },
                                         { name: "CUSTOMER_ID", value: "4711" },
                                         { name: "PROFILE_ID", value: "12" },
                                         { name: "PROFILE_STATUS", value: "IGNORED" },
                                         { name: "FILTER_STATUS", value: "some filter status" },
                                         { name: "APPR_CODE", value: "-test-" } ]))

        allow(Order::MPAY_TEST_CLIENT).to receive(:call) { response }
        @payment = create(:payment)
      end

      it "creates a new confirmation" do
        @payment.check_transaction_status
        expect(@payment.confirmations.first).to be_a MercatorMpay24::Confirmation
      end

      it "assigns the attributes in succuss case" do
        @payment.check_transaction_status
        @confirmation = @payment.confirmations.first
        expect(@confirmation.payment_id).to eql @payment.id
        expect(@confirmation.status).to eql "BILLED"
        expect(@confirmation.operation).to eql "CONFIRMATION"
        expect(@confirmation.tid).to eql "50"
        expect(@confirmation.price).to eql "101520"
        expect(@confirmation.currency).to eql "EUR"
        expect(@confirmation.p_type).to eql "CC"
        expect(@confirmation.brand).to eql "VISA"
        expect(@confirmation.mpaytid).to eql "1793508"
        expect(@confirmation.user_field).to eql "219ff7718187c30ae3f41f05715c9dac0e1f075f25cc9782ed4..."
        expect(@confirmation.orderdesc).to eql "Warenkorb vom Mo, 9.Feb 15,  9:17"
        expect(@confirmation.customer).to eql "50"
        expect(@confirmation.customer_email).to eql "customer@email.com"
        expect(@confirmation.language).to eql "DE"
        expect(@confirmation.customer_id).to eql "4711"
        expect(@confirmation.profile_id).to eql "12"
        expect(@confirmation.profile_status).to eql "IGNORED"
        expect(@confirmation.filter_status).to eql "some filter status"
        expect(@confirmation.appr_code).to eql "-test-"
      end

      it "calls update order" do
        expect_any_instance_of(MercatorMpay24::Confirmation).to receive(:update_order)
        @payment.check_transaction_status
      end
    end
  end
end