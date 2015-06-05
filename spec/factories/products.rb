FactoryGirl.define do

  factory :product do
    title_de            "default product"
    title_en            "Article One Two Three"
    number              "123"
    state               "active"
    description_de      "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid."
    description_en      "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!"
    long_description_de "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid."
    long_description_en "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!"
    warranty_de         "Ein Jahr mit gewissen Einschränkungen"
    warranty_en         "One year with evereal restrictions"
    photo               { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    document            { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') }

    factory :new_product do
      number "new_product"
      state    "new"
    end

    factory :product_with_inventory do
      number "product_with_inventory"
      after(:create) do |product, evaluator|
        create(:inventory, product: product)
      end
    end

    factory :product_with_inventory_and_two_prices do
      number "product_with_inventory_and_two_prices"
      after(:create) do |product, evaluator|
        create(:inventory_with_two_prices, product: product)
      end
    end

    factory :product_with_inventory_and_lower_price do
      number "cheaper product"
      after(:create) do |product, evaluator|
        create(:inventory_with_lower_price, product: product)
      end
    end

    factory :product_in_category do
      number "product_in_category"
      after(:create) do |product, evaluator|
        create(:categorization, category_id: create(:category).id,
                                product_id: product.id)
      end
    end

    factory :product_with_two_inventories do
      number "product_with_two_inventories "
      after(:create) do |product, evaluator|
        create(:inventory, product: product)
        create(:inventory, product: product,
                           created_at: Time.now - 1.day)
      end
    end

    factory :shipping_cost_article do
      number "VERSANDSPESEN"
      after(:create) do |product, evaluator|
        create(:inventory, product: product, number: "VERSANDSPESEN")
      end
    end
  end

  factory :second_product , class: Product do
    title_de            "Artikel Zwei"
    title_en            "Article Two"
    number              "42"
    state "active"
    description_de      "Deutsch: Noch ein Text."
    description_en      "English: Another Text!"
    long_description_de "Deutsch: Noch ein Text."
    long_description_en "English: Another Text!"
    warranty_de         "Ein Monat mit gewissen Einschränkungen"
    warranty_en         "One month with evereal restrictions"
    photo               { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    document            { fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') }

    factory :third_product do
      number   "number 3"
      title_de "Artikel Drei"
      title_en "Article Three"
      photo    nil
      document nil
    end
  end
end