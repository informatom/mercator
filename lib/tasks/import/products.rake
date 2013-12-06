def import_products
  puts "\n\nProducts:"
  Product.all.each do |product|
    product.delete
  end
  print "Products deleted."

  Legacy::Product.all.each do |legacy_product|
    legacy_product_de = legacy_product.product_translations.german.first
    legacy_product_en = legacy_product.product_translations.english.first

    if legacy_product_de && legacy_product_de.title.present?
      name_de = legacy_product_de.title
    else
      name_de = legacy_product.name
    end

    if legacy_product_de && legacy_product_de.long_description.present?
      description_de = legacy_product_de.long_description
    else
      description_de = "fehlt"
    end

    if legacy_product_en && legacy_product_en.title.present?
      name_en = legacy_product_en.title
    else
      name_en = legacy_product.name
    end

    if legacy_product_en && legacy_product_en.long_description.present?
      description_en = legacy_product_en.long_description
    else
      description_en = "missing"
    end

    if product = Product.create(number: legacy_product.article_number,
                      name_de: name_de,
                      name_en: name_en,
                      description_de: description_de,
                      description_en: description_en,
                      legacy_id: legacy_product.id)
      print "P"
    else
      puts "\nFAILURE: Product: " + product.errors.first.to_s
    end
  end
end