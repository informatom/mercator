task :products2 => :environment do # attachments ???
  hp_pics = "/Users/shm/_work/ivelliovelin/mesonic_pics"

  Product.all.each do |product|
    image_name = product.inventory.send( "Grafikfile" )

    if image_name
      image_name =~ /(.+)\_\d*[xX]?\d*\..../
      image_name = $1 if $1

      images = Dir.new( hp_pics ).grep(/#{image_name.downcase}/i)
      unless images.empty?
        path = File.join( hp_pics, images.sort.first )
        mimetype = `file -ib #{path}`.gsub(/\n/,"")
        attach = Attachment.create(:uploaded_data => ActionController::TestUploadedFile.new( path, mimetype ), :name => File.basename(path) )
        attach.klass = "overview"
        attach.save
      end
      product.attachments << attach if attach
    end
  end
end




def product_xml_filename( prod_id )
  xml = LibXML::XML::Document.io( xml_io )
  result = xml.find("//file[@Prod_ID='#{prod_id}']")
  return nil if result.empty?
  result.first.attributes["path"]
end