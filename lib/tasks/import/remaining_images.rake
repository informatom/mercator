def import_remaining_images
  require 'net/http'
  puts "\n\nCMS Images:"

  Net::HTTP.start("www.iv-shop.at") do |http|
    Legacy::Content.where(typus: "ImageContent").each do |legacy_content|

      content_element = ContentElement.new(name_de: legacy_content.name, markup: "html")

      legacy_attachable = Legacy::Attachable.where(attachable_type: "Content", attachable_id: legacy_content.id).first
      unless legacy_attachable
        puts "\nFAILURE: Attachable not found " + legacy_content.id.to_s
        next
      end

      filename = "/system/datas/" + legacy_attachable.asset_id.to_s + "/original/" + legacy_content.name
      data = StringIO.new(http.get(filename).body)
      unless data
        puts "\nFAILURE: Image not found " + filename
        next
      end

      data.class.class_eval { attr_accessor :original_filename }
      data.original_filename = legacy_content.name

      content_element.photo = data

      if content_element.save
        print "C"
      else
        puts "\nFAILURE: ContentElement: " + content_element.errors.first.to_s
      end

      legacy_content.delete()
      legacy_attachable.delete()
    end
  end
end