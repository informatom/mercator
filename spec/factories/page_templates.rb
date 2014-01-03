# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page_template do
    name "Standard"
    content "<span>some  html</span>"
  end
end
