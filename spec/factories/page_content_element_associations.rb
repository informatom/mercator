FactoryGirl.define do

  factory :page_content_element_assignment do
    used_as "title"
    webpage
    content_element
  end
end