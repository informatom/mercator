FactoryGirl.define do

  factory :category do
    name_de             "Drucker"
    name_en             "Printer"
    description_de      "Tolle Drucker"
    description_en      "Fantastic Printers"
    long_description_de "In der Tat tolle Drucker"
    long_description_en "Fantastic Printers, indeed."
    position            42
    photo               { fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    document            { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') }
  end

end