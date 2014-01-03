def import_cms
  puts "\n\nPages:"

  Legacy::CmsNode.where(type: "Page").each do |legacy_cms_node|
    legacy_cms_node_de = legacy_cms_node.cms_node_translations.german.first
    legacy_cms_node_en = legacy_cms_node.cms_node_translations.english.first
     
    status = legacy_cms_node.state
    status = "published_but_hidden" if legacy_cms_node.hide_from_menu? && legacy_cms_node.state == "published"
    if page = Page.create(title_de: legacy_cms_node_de.title,
                          title_en: legacy_cms_node_en.title,
                          status: status
                          ) 
      print "P"
    else
      puts "\nFAILURE: Page: " + page.errors.first.to_s
    end
  end
end