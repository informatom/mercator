def import_properties
  puts "\n\nProperty Groups and Properties:"
  Property.all.each do |property|
    property.delete
  end
  print "Properties deleted."
  PropertyGroup.all.each do |property_group|
    property_group.delete
  end
  print "Property Groups deleted."

  Legacy::Product.all.each do |legacy_product|
    product = Product.find_by_legacy_id(legacy_product.id)
    debugger unless product
    legacy_product.properties.each do |legacy_property|
      legacy_property_de = legacy_property.property_translations.german.first
      legacy_property_en = legacy_property.property_translations.english.first

      property_group = PropertyGroup.find_or_initialize_by_name_de_and_product_id(legacy_property_de.group,
                                                                                  product.id)
      if property_group.update_attributes(name_en: legacy_property_en.group,
                                          position: 1)
        print "G"

        if property = Property.create(name_de: legacy_property_de.name,
                                      property_group_id: property_group.id,
                                      name_en: legacy_property_en.name,
                                      description_de: legacy_property.presentation_value,
                                      description_en: legacy_property.presentation_value,
                                      position: 1,
                                      legacy_id: legacy_property.id)
          print "p"
        else
          puts "\nFAILURE: Property: " + property.errors.first.to_s
        end
      else
        puts "\nFAILURE: PropertyGroup: " + property_group.errors.first.to_s
      end
    end
  end
end