FactoryGirl.define do

  factory :toner do
    article_number "TR0815"
    description    "Toner schwarz"
    vendor_number  "HP-TR0815"
    price          "42.15"

    factory :second_toner do
      article_number "TY0816"
      description    "Toner gelb"
      vendor_number  "HP-TR0816"
      price          "12"
    end
  end
end