FactoryGirl.define do

  factory :category do
    name_de  "Drucker"
    name_en  "Printer"
    description_de "Tolle Drucker"
    description_en "Fantastic Printers"
    long_description_de "In der Tat tolle Drucker"
    long_description_en "Fantastic Printers, indeed."
    position 42
  end

end