def import_countries
  puts "\n\nCountries:"

  Legacy::Country.all.each do |legacy_country|
    country = Country.find_or_initialize_by_name_de(legacy_country.country_name)
    if country.update_attributes(name_en: legacy_country.country_name,
                                 code: legacy_country.country_a2,
                                 legacy_id: legacy_country.id)
      print "C"
    else
      puts "\nFAILURE: Country: " + country.errors.first.to_s
    end
  end
end