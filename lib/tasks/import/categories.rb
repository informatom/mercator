def import_categories
  puts "\n\nCategories:"
    Category.all.each do |category|
    category.delete
  end
  print "Categories deleted."

  Legacy::Category.all.each do |legacy_category|
    legacy_category_de = legacy_category.category_translations.german.first
    legacy_category_en = legacy_category.category_translations.english.first

    category = Category.create(name_de: legacy_category_de.title && legacy_category.name)
    parent = Category.find_by_legacy_id(legacy_category.parent_id)
    if category.update_attributes(name_en: legacy_category_en.title,
                                 description_de: legacy_category_de.short_description,
                                 description_en: legacy_category_en.short_description,
                                 long_description_de: legacy_category_de.long_description,
                                 long_description_en:  legacy_category_en.long_description,
                                 position:  legacy_category.position,
                                 parent: ( parent if parent ) ,
                                 legacy_id: legacy_category.id)
      category.activate if legacy_category.active == "1"
      print "C"
    else
      puts "\nFAILURE: Category " + category.errors.first.to_s
    end
  end
end