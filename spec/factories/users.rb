FactoryGirl.define do

  factory :user do
    first_name       "John"
    gender           :male
    surname          "Doe"
    email_address    "john.doe@informatom.com"
    sales            false
    sales_manager    false
    administrator    false
    password         "secret123"
    last_login_at    "2014-01-22 15:23"
    gtc_confirmed_at "2014-01-22 15:23"
    gtc_version_of   "2014-01-22"
    erp_account_nr   "a123"
    erp_contact_nr   "b123"


    factory :dummy_customer do
      surname "Dummy Customer"
    end


    factory :admin do
      first_name "Albert"
      surname "Administator"
      email_address "albert.administator@informatom.com"
      administrator true

      factory :jobuser do
        surname "Job User"
      end

      factory :robot do
        surname "Robot"
      end
    end


    factory :sales do
      first_name "Sammy"
      surname "Sales Representative"
      email_address "sammy.sales@informatom.com"
      sales true

      factory :content_manager do
        first_name "Carlo"
        surname "Content Manager"
        email_address "carlo.contentmanager@informatom.com"
        contentmanager true
      end

      factory :salesmanager do
        first_name "Sally"
        surname "Sales Manager"
        email_address "sally.salesmanager@informatom.com"
        sales_manager true
      end

      factory :productmanager, class: User do
        first_name "Pete"
        surname "Product Manager"
        email_address "pete.productmanager@informatom.com"
        productmanager true
      end
    end
  end
end