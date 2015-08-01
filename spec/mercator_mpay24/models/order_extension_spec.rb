require 'spec_helper'

describe Order do
  before :each do
    create(:mpay_test_username)
    create(:mpay_test_password)

    Order::MERCHANT_TEST_ID = Constant.find_by_key("mpay_test_username").value

    Order::MPAY_TEST_CLIENT =
      Savon.client(basic_auth: ["u" + Order::MERCHANT_TEST_ID,
                                      Constant.find_by_key("mpay_test_password").value ],
                   wsdl: "https://test.mpay24.com/soap/etp/1.5/ETP.wsdl",
                   endpoint: "https://test.mpay24.com/app/bin/etpproxy_v15",
                   logger: Rails.logger, log_level: :info, log: true, pretty_print_xml: true)
  end

  after :each do
    Order.send(:remove_const, :MERCHANT_TEST_ID)
    Order.send(:remove_const, :MPAY_TEST_CLIENT)
  end

  it "has many payments" do
    it {should have_many :payments}
  end

  it "sets MERCHANT_TEST_ID" do
    expect(Order::MERCHANT_TEST_ID).to eql "12345"
  end

  it "sets MPAY_TEST_CLIENT" do
    expect(Order::MPAY_TEST_CLIENT).to be_a Savon::Client
  end


  # --- Instance Methods --- #

  describe "pay" do
    before :each do
      create(:constant_shipping_cost)
      @user = create(:user)
      @order = create(:order, state: "active",
                              user_id: @user.id)
      @lineitem = create(:lineitem, order_id: @order.id,
                                    user_id: @user.id)
      @supply = create(:second_product)
      @another_lineitem = create(:lineitem, order_id: @order.id,
                                            user_id: @user.id,
                                            product_id: @supply.id,
                                            product_number: @supply.number,
                                            product_price: 66,
                                            value: 88,
                                            description_de: @supply.description_de,
                                            description_en: @supply.description_en)

      allow_any_instance_of(Savon::Client).to receive(:call).and_return("some response")
      Constant.send(:remove_const, :SHOPDOMAIN) # just to avoid warning in the next line
      Constant::SHOPDOMAIN = create(:shop_domain).value
    end

    it "sets client" do
      @order.pay
      expect(@order.instance_variable_get(:@client)).to be_a Savon::Client
    end

    it "creates payment" do
      @order.pay
      expect(@order.payments.first).to be_a MercatorMpay24::Payment
    end

    it "sets the payments attributes" do
      @order.pay
      @payment = @order.payments.first
      @expected_xml = "<xml>
                         <merchantID>undefined</merchantID>
                         <mdxi>
                           <Order>
                           <UserField>5fa94bcc28dd81d5f01f3bc8e9f57973efc790613b6027c67c2b64c416de2f53</UserField>
                           <Tid>" + @payment.id.to_s + "</Tid>
                           <ShoppingCart>
                             <Description>" + @order.name + "</Description>
                             <Item>
                               <Number>123</Number>
                               <ProductNr>42</ProductNr>
                               <Description>English: Another Text!</Description>
                               <Quantity>42</Quantity>
                               <ItemPrice>66.00</ItemPrice>
                               <Price>88.00</Price>
                              </Item>
                              <Item>
                                <Number>124</Number>
                                <ProductNr>nr123</ProductNr>
                                <Description>Article One Two Three</Description>
                                <Quantity>42</Quantity>
                                <ItemPrice>123.45</ItemPrice>
                                <Price>5184.90</Price>
                              </Item>
                              <ShippingCosts Tax=\"0.00\">0.00</ShippingCosts>
                              <Tax>1028.22</Tax>
                              <Discount>131.82</Discount>
                            </ShoppingCart>
                            <Price>6169.29</Price>
                            <URL>
                              <Success>http://shop.domain.com/orders/" + @order.id.to_s + "/payment_status</Success>
                              <Error>http://shop.domain.com/orders/" + @order.id.to_s + "/payment_status</Error>
                              <Confirmation>http://shop.domain.com/mercator_mpay24/confirmation</Confirmation>
                              <Cancel>http://shop.domain.com/orders/" + @order.id.to_s + "/payment_status</Cancel>
                            </URL>
                          </Order>
                        </mdxi>
                      </xml>"

      expect(@payment.merchant_id).to eql "undefined"
      expect(@payment.order_id).to eql @order.id
      expect(@payment.user_field_hash.length).to eql 64
      expect(@payment.tid).to eql @payment.id.to_s

      JsonSpec.configure do
        exclude_keys "created_at", "updated_at", "UserField"
      end
      expect(Hash.from_xml("<xml>" + @payment.order_xml + "</xml>").to_json).to be_json_eql(Hash.from_xml(@expected_xml).to_json)

      JsonSpec.configure do
        exclude_keys "created_at", "updated_at"
      end
    end

    it "returns the response" do
      expect(@order.pay).to eql "some response"
    end
  end


# The XmlMessage Class is tested by the test of the pay instance method above
end