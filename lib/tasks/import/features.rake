def import_features
  puts "\n\nFeatures:"

  n=1
  Legacy::ProductOverviewProperty.all.each do |legacy_product_overview_property|
    legacy_product = Product.find_by_legacy_id(legacy_product_overview_property.product_id)
    unless legacy_product
      puts "\nFAILURE: Product not found: " + legacy_product_overview_property.product_id.to_s
      next
    end
    feature = Feature.create(text_de: legacy_product_overview_property.description,
                             position: ( legacy_product_overview_property.order || n = n + 1 ),
                             product_id: legacy_product.id,
                             legacy_id: legacy_product_overview_property.id)
    if feature.save
      print "F"
    else
      puts "\nFAILURE: Feature: " + feature.errors.first.to_s
    end
  end
end