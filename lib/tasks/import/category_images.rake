def import_category_images
  require 'net/http'
  puts "\n\nCategory Images:"

  assets = []

  Net::HTTP.start("www.iv-shop.at") do |http|
    Legacy::Attachable.where(attachable_type: "Category").each do |legacy_attachable|

      category = Category.where(legacy_id: legacy_attachable.attachable_id).first

      unless category
        puts "\nFAILURE: Category not found: " + legacy_attachable.attachable_id.to_s
        next
      end

      unless legacy_attachable.asset
        puts "\nFAILURE: Asset not found: " + legacy_attachable.asset_id.to_s
        next
      end

      filename = "/system/datas/" + legacy_attachable.asset.id.to_s +
                 "/original/" + legacy_attachable.asset.data_file_name

      data = StringIO.new(http.get(filename).body)

      unless data
        puts "\nFAILURE: Image not found " + filename
        next
      end

      data.class.class_eval { attr_accessor :original_filename }
      data.original_filename = legacy_attachable.asset.data_file_name
      category.photo = data

      if category.save
        print "C"
        assets << legacy_attachable.asset
        legacy_attachable.delete()
      else
        puts "\nFAILURE: Category: " + category.first.to_s
      end
    end
  end

  assets.each do |asset|
    asset.delete()
  end
end