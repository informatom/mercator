FactoryGirl.define do

  factory :product do
    title_de            "Artikel Eins Zwei Drei"
    title_en            "Article One Two Three"
    number              123
    description_de      "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid."
    description_en      "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!"
    long_description_de "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid."
    long_description_en "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!"
    warranty_de         "Ein Jahr mit gewissen Einschränkungen"
    warranty_en         "One year with evereal restrictions"
    photo               { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    document            { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') }
  end

  factory :second_product , class: Product do
    title_de            "Artikel Zwei"
    title_en            "Article Two"
    number              42
    description_de      "Deutsch: Noch ein Text."
    description_en      "English: Another Text!"
    long_description_de "Deutsch: Noch ein Text."
    long_description_en "English: Another Text!"
    warranty_de         "Ein Monat mit gewissen Einschränkungen"
    warranty_en         "One month with evereal restrictions"
    photo               { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    document            { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') }
  end
end