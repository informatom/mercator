# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :blogpost, :class => 'Blogpost' do
    content_element
    post_category
    title_de "Erster Blogpost"
    title_en "First Blogpost"
  end
end
