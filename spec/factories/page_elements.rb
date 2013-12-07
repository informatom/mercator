# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page_element do
    used_as "title"
    page
    association :usage, factory: :content_element
  end
end
