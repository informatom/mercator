FactoryGirl.define do

  factory :user do
    first_name       "John"
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
  end

  factory :admin, class: User do
    first_name "Albert"
    surname "Administator"
    email_address "albert.administator@informatom.com"
    administrator true
    password "secret123"
    last_login_at "2014-01-22 15:23"
    gtc_confirmed_at "2014-01-22 15:23"
    gtc_version_of "2014-01-22"
    erp_account_nr "a123"
    erp_contact_nr "b123"

    factory :jobuser do
      surname "Job User"
    end
  end

  factory :sales, class: User do
    first_name "Sammy"
    surname "Sales Representative"
    email_address "sammy.sales@informatom.com"
    sales true
    sales_manager false
    administrator false
    password "secret123"
    last_login_at "2014-01-22 15:23"
    gtc_confirmed_at "2014-01-22 15:23"
    gtc_version_of "2014-01-22"
    erp_account_nr "a123"
    erp_contact_nr "b123"
  end

  factory :salesmanager, class: User do
    first_name "Sally"
    surname "Sales Manager"
    email_address "sally.salesmanager@informatom.com"
    sales true
    sales_manager true
    administrator false
    password "secret123"
    last_login_at "2014-01-22 15:23"
    gtc_confirmed_at "2014-01-22 15:23"
    gtc_version_of "2014-01-22"
    erp_account_nr "a123"
    erp_contact_nr "b123"
  end
end