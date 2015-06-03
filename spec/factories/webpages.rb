FactoryGirl.define do

  factory :webpage do
    title_de "Titel einer Website"
    title_en "Titel of a Webpage"
    slug     "mypage"
    url      "/url/to/page"
    position 1
    page_template
  end
end