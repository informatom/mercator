FactoryGirl.define do

  factory :category do
    state               "active"
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
    photo               nil
    document            nil

    factory :category_with_active_product do
      name_de "category_with_active_product"
      after(:create) do |category, evaluator|
        create(:categorization, product: create(:product, number: category.name_de + "'s product"),
                                category: category)
      end
    end
  end
end