FactoryGirl.define do

  factory :product do
    title_de        "Artikel Eins Zwei Drei"
    title_en        "Article One Two Three"
    number         123
    description_de "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid."
    description_en "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!"
    photo          { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    document       { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') }
  end
end