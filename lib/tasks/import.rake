# encoding: utf-8
require 'faker'
$stdout.sync = true

namespace :import do
  # starten als: 'bundle exec rake import:legacy
  # in Produktivumgebungen: 'bundle exec rake import:legacy RAILS_ENV=production'
  desc "Import from legacy webshop"
  task :legacy => :environment do

    # puts "\nUsers:"
    # Legacy::User.all.each do |legacy_user|
    #   user = User.find_or_initialize_by_name(legacy_user.name)
    #   if user.update_attributes(email_address: legacy_user.email,
    #                             legacy_id: legacy_user.id)
    #       print "U"
    #   else
    #     puts "\nFAILURE: User: " + user.errors.first.to_s
    #   end
    # end

    # puts "\n\nCountries:"
    # Legacy::Country.all.each do |legacy_country|
    #   country = Country.find_or_initialize_by_name_de(legacy_country.country_name)
    #    if country.update_attributes(name_en: legacy_country.country_name, 
    #                                 code: legacy_country.country_a2,
    #                                 legacy_id: legacy_country.id)
    #      print "C"
    #    else
    #      puts "\nFAILURE: Country: " + country.errors.first.to_s
    #    end
    # end

    puts "\n\nProducts:"
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

      product = Product.find_or_initialize_by_name_de(name_de)
      if product.update_attributes(name_en: name_en, 
                                   number: legacy_product.article_number,
                                   description_de: description_de,
                                   description_en: description_en,
                                   legacy_id: legacy_product.id)
        print "P"

        legacy_product.properties.each do |legacy_property|
          legacy_property_de = legacy_property.property_translations.german.first
          legacy_property_en = legacy_property.property_translations.english.first

          property_group = PropertyGroup.find_or_initialize_by_name_de_and_product_id(legacy_property_de.group, 
                                                                                      product.id)
          if property_group.update_attributes(name_en: legacy_property_en.group,
                                              position: 1)
            print "G"
            property = Property.find_or_initialize_by_name_de_and_property_group_id(legacy_property_de.name,
                                                                                     property_group.id)
            if property.update_attributes(name_en: legacy_property_en.name,
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
      else
        puts "\nFAILURE: Product: " + product.errors.first.to_s
      end
    end
  end
end