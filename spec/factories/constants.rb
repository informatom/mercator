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

    factory :constant_shop_domain do
      key :shop_domain
      value "shop.domain.com"
    end

    factory :constant_cms_domain do
      key :cms_domain
      value "cms.domain.com"
    end

    factory :mpay_test_username do
      key   :mpay_test_username
      value "12345"
    end

    factory :mpay_test_password do
      key   :mpay_test_password
      value "secret"
    end

    factory :prices_are_set_by_erp_and_therefore_not_editable do
      key   :prices_are_set_by_erp_and_therefore_not_editable
      value "true"
    end
  end
end