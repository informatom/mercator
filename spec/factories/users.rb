# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "John Doe"
    email_address "john.doe@informatom.com"
    administrator false
  end

  factory :admin, class: User do
    name "Albert Administator"
    email_address "albert.administator@informatom.com"
    administrator true
  end
end
