def import_pages
  puts "\n\nPages:"

  Legacy::CmsNode.where(typus: "Page").each do |legacy_cms_node|
    legacy_cms_node_de = legacy_cms_node.cms_node_translations.german.first
    legacy_cms_node_en = legacy_cms_node.cms_node_translations.english.first

    page_template = PageTemplate.where(legacy_id: legacy_cms_node.page_template_id).first
    parent = Page.where(legacy_id: legacy_cms_node.parent_id).first

    status = legacy_cms_node.state
    status = "published_but_hidden" if legacy_cms_node.hide_from_menu? && legacy_cms_node.state == "published"
    page = Page.new(title_de: ( legacy_cms_node_de.title.present? ? legacy_cms_node_de.title : legacy_cms_node.name ),
                    title_en: legacy_cms_node_en.title,
                    url: legacy_cms_node.url,
                    position: legacy_cms_node.position,
                    parent_id: ( parent.id if parent ),
                    page_template_id: page_template.id,
                    legacy_id: legacy_cms_node.id)
    page.state = status
    if page.save
      print "P"
    else
      puts "\nFAILURE: Page: " + page.errors.first.to_s
    end
  end
end