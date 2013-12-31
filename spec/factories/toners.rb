# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :toner do
    article_number "TR0815"
    description    "Toner schwarz"
    vendor_number  "HP-TR0815"
    price          "42.15"
  end
end
