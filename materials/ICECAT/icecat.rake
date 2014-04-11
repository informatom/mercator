namespace :icecat do
  namespace :import do

    desc "import product_xml_filenames from full.index.xml"
    task :meta_data => :environment do

      if( ENV.include?('INDEX') && !ENV['INDEX'].empty? )
        filename = ENV['INDEX']
      else
        filename = File.join( RAILS_ROOT, "tmp", "icecat", "full.index.xml" )
        File.open( filename, "w" ) do |f|
          f.puts Icecat::Access.new.full_index.read
        end
      end
      puts "loading index xml '#{filename}'"

      xml = LibXML::XML::Document.file( filename )
      products = Product.scoped({:conditions => { :icecat_product_xml => nil } } )
      j = products.count
      i = 1

      products.all.each do |product|
        product.import_icecat_meta_data( xml )
        puts "#{product.save} #{i}/#{j}"
        i = i + 1
      end
      xml = nil
    end

    desc "import related products from icecat product xml files"
    Icecat::Import.products(:related_products)

    desc "import images from icecat product xml files"
    Icecat::Import.products(:images)

    desc "import icecat data for all products"
    importer = Icecat::Import.new( logger )
    importer.full

    task :pictures => :environment do
      icecat_importer = Icecat::Import.new( true, "/Users/shm/_work/ivelliovelin/rails/ivellio_08/icecat_xmls/full_20090414_164816" )
      icecat_importer.products_pictures
    end
  end

  task :products2 => :environment do # attachments ???
    i = Product.count
    j = 1
    hp_pics = "/Users/shm/_work/ivelliovelin/mesonic_pics"


    Product.all.each do |product|
      image_name = product.inventory.send( "Grafikfile" )

      attach = nil
      if image_name
        image_name =~ /(.+)\_\d*[xX]?\d*\..../
        image_name = $1 if $1

        images = Dir.new( hp_pics ).grep(/#{image_name.downcase}/i)
        unless images.empty?
          path = File.join( hp_pics, images.sort.first )
          mimetype = `file -ib #{path}`.gsub(/\n/,"")
          attach = Attachment.create(
            :uploaded_data => ActionController::TestUploadedFile.new( path, mimetype ),
            :name => File.basename(path)
          )
          attach.klass = "overview"
          attach.save
        end

        product.attachments << attach if attach
        i = i + 1
      end
    end
  end
end