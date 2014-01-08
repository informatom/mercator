FactoryGirl.define do

  factory :user do
    name "John Doe"
    email_address "john.doe@informatom.com"
    administrator false
    password "secret123"
  end

  factory :admin, class: User do
    name "Albert Administator"
    email_address "albert.administator@informatom.com"
    administrator true
    password "secret123"
  end

  factory :sales, class: User do
    name "Sammy Sales Representative"
    email_address "sammy.sales@informatom.com"
    administrator true
    password "secret123"
  end

end