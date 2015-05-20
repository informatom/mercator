FactoryGirl.define do

  factory :constant do
    key   "Example key"
    value "Example value"

    factory :office_hours do
      key   :office_hours
      value '{MON: ["8:30", "17:00"], TUE: ["8:30", "17:00"], WED: ["8:30", "17:00"], THU: ["8:30", "17:00"], FRI: ["8:30", "12:30"]}'
    end

    factory :cms_domain do
      key   :cms_domain
      value "cms.domain.com"
    end

    factory :shop_domain do
      key   :shop_domain
      value "shop.domain.com"
    end

    factory :constant_fifo do
      key   :fifo
      value "true"
    end

    factory :constant_shipping_cost do
      key   :shipping_cost_article
      value "VERSANDSPESEN"
    end

    factory :constant_service_mail do
      key   :service_mail
      value "mail@informatom.com"
    end

    factory :mail_subject do
      key   :order_notify_in_payment_mail_subject
      value "subject"
    end
  end
end