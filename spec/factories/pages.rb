# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title_de "Titel einer Website"
    title_en "Titel of a Webpage"
    url      "/url/to/page"
    position 1
    page_template
  end
end
