FactoryGirl.define do

  factory :content_element do
    folder
    name_de    "Ich bin der deutsche Titel"
    name_en    "I am the engish title"
    content_de "Ich bin der deutsche Inhalt"
    content_en "I am the English content"
    markup     "html"
    legacy_id  10
    photo      { fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    document   { fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') }
  end
end