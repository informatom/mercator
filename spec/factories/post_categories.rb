# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_category do
    name_de "Wichtige Blogposts"
    name_en "Important Blogposts"
    ancestry nil
  end
end