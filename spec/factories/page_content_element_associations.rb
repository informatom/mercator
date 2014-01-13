# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page_content_element_assignment do
    used_as "title"
    webpage
    content_element
  end
end
