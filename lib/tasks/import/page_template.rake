def import_page_templates
  puts "\n\nPage Templates:"

  Legacy::PageTemplate.all.each do |legacy_page_template|
    if page_template = PageTemplate.create(name: legacy_page_template.name,
                                           content: legacy_page_template.content,
                                           legacy_id: legacy_page_template.id) 
      print "T"
    else
      puts "\nFAILURE: PageTemplate: " + page_template.errors.first.to_s
    end
  end
end