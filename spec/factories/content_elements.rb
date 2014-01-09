FactoryGirl.define do

  factory :content_element do
    name_de    "Ich bin der deutsche Titel"
    content_de "Ich bin der deutsche Inhalt"
    markup     "html"
    name_en    "I am the engish title"
    content_en "I am the English content"
    photo      { fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    document   { fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') } 
  end

end