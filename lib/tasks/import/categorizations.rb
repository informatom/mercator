def import_categorizations
  puts "\n\nCategorizations:"
  fehler = 0

  Legacy::Product.all.each do |legacy_product|
    product_id = Product.find_by_legacy_id(legacy_product.id)

    if legacy_product.article_group && legacy_product.article_group.length == 11
      legacy_product.article_group = "00" + legacy_product.article_group[0..3] +
                                     "00" + legacy_product.article_group[4..7] +
                                     "00" + legacy_product.article_group[8..10] +
                                     "-00000-00000"
    end

    if legacy_category = Legacy::Category.find_by_category_product_group(legacy_product.article_group)
      category_id = Category.find_by_legacy_id(legacy_category.id)

      if Categorization.find_or_initialize_by_product_id_and_category_id(product_id, category_id)
        print "…"
      else
        puts "\nFAILURE: Categorization " + categorization.errors.first.to_s
        fehler+= 1
      end
    else
       puts "\nFAILURE: Category " + legacy_product.article_group.to_s + " not found."
       fehler+= 1
    end
  end
  puts fehler.to_s + " Fehler"
end