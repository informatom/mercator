FactoryGirl.define do

  factory :payment,:class => 'MercatorMpay24::Payment' do
    order            {create(:order_in_payment)}
    merchant_id      93537
    tid              42
    user_field_hash  "0076a66e2734c1b681b545dc5f83a23a4850ac4466fd2e09c347a37c90172d34"
    order_xml        <<END_HEREDOC
<merchantID>93537</merchantID>
<mdxi>
  <Order>
    <UserField>0076a66e2734c1b681b545dc5f83a23a4850ac4466fd2e09c347a37c90172d34</UserField>
    <Tid>67</Tid>
    <ShoppingCart>
      <Description>Bestellung vom Mo, 9.Feb 15, 12:05</Description>
      <Item>
        <Number>10</Number>
        <ProductNr>HP-D5T59EA</ProductNr>
        <Description>HP ProDesk 490  (i3-4130 4GB 500GB)</Description>
        <Quantity>1</Quantity>
        <ItemPrice>426.00</ItemPrice>
        <Price>426.00</Price>
      </Item>
      <ShippingCosts Tax="0.00">0.00</ShippingCosts>
      <Tax>85.20</Tax>
      <Discount>0.00</Discount>
    </ShoppingCart>
    <Price>511.20</Price>
    <URL>
      <Success>http://shop.domain.com:3000/orders/147/payment_status</Success>
      <Error>http://shop.domain.com:3000/orders/147/payment_status</Error>
      <Confirmation>http://shop.domain.com:3000/mercator_mpay24/confirmation</Confirmation>
      <Cancel>http://shop.domain.com:3000/orders/147-bestellung-vom-mo-9-feb-15/payment_status</Cancel>
    </URL>
  </Order>
</mdxi>
END_HEREDOC

  end
end