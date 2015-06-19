FactoryGirl.define do

  factory :confirmation,:class => 'MercatorMpay24::Confirmation' do
    payment
    operation      "CONFIRMATION"
    tid            "50"
    status         "BILLED"
    price          "101520"
    currency       "EUR"
    p_type         "CC"
    brand          "VISA"
    mpaytid        "1793508"
    user_field     "219ff7718187c30ae3f41f05715c9dac0e1f075f25cc9782ed4..."
    orderdesc      "Warenkorb vom Mo, 9.Feb 15,  9:17"
    customer       "50"
    customer_email "customer@email.com"
    language       "DE"
    customer_id    "4711"
    profile_id     "12"
    profile_status "IGNORED"
    filter_status  "some filter status"
    appr_code      "-test-"
  end
end