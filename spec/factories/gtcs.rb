# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gtc do
    title_de "Minimale AGBS"
    title_en "Minimal GTCs"
    content_de "Einige Bedingungen"
    content_en "Some terms and conditions"
    version_of "2014-01-22"
  end
end
