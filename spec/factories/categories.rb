FactoryGirl.define do

  factory :category do
    name_de             "Drucker"
    name_en             "Printer"
    description_de      "Tolle Drucker"
    description_en      "Fantastic Printers"
    long_description_de "In der Tat tolle Drucker"
    long_description_en "Fantastic Printers, indeed."
    ancestry            nil
    position            42
    legacy_id           42
    filters             { ["name_de", "Drucker"] }
    filtermin           42
    filtermax           4242
    erp_identifier      "0815"
    usage               :standard
    squeel_condition    ""
    photo               { fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    document            { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') }
  end
end