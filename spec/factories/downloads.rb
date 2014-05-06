# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :download do
    name     "Ich bin ein Download"
    document { fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') }
    photo { fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    conversation
  end
end
