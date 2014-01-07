def import_remaining_assets
  require 'net/http'
  puts "\n\nCMS Assets:"

  Net::HTTP.start("www.iv-shop.at") do |http|
    Legacy::Asset.where(data_content_type:  "application/pdf").each do |legacy_asset|

      if ContentElement.find_by(name_de: legacy_asset.data_file_name, markup: "html")
        puts "\nFAILURE: Image exists " + legacy_asset.data_file_name
        legacy_asset.delete()
        next
      end

      content_element = ContentElement.new(name_de: legacy_asset.data_file_name, markup: "html")

      filename = "/system/datas/" + legacy_asset.id.to_s + "/original/" + legacy_asset.data_file_name
      data = StringIO.new(http.get(filename).body)
      unless data
        puts "\nFAILURE: Image not found " + filename
        next
      end

      data.class.class_eval { attr_accessor :original_filename }
      data.original_filename = legacy_asset.data_file_name

      content_element.document = data

      if content_element.save
        print "C"
      else
        puts "\nFAILURE: ContentElement: " + content_element.errors.first.to_s
      end

      legacy_asset.delete()
    end
  end
end