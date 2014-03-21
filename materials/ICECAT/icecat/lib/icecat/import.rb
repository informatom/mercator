require 'icecat/url2xml'
module Icecat
  
  class Import

    class << self ;
      
      def products( t = :full, file = nil )
        i = new
        i.set_xml( file ) if t == :daily
        i.send( t )
      end
    end
    
    def initialize( log = Logger.new( File.join( RAILS_ROOT, "log", "icecat.log" ) ) )
      @logg = log
      @import_timestamp = Time.now
    end
    
    def say message
      @logg.info( "[import:full] #{message}" )
    end

    
    def related_products
      products = ::Product.scoped( { :conditions => ["icecat_product_xml IS NOT NULL" ] } )
      j = 1
      i = products.count
      products.all.each do |product|
        begin
          product.import_related_products
          say "Product save : #{product.save} : (#{j}/#{i})"
          j = j + 1
        rescue Exception => e
          say "Exception occured while importing related products for product ##{product.id} (#{e})"
        end
      end
    end
    
    
    def images
      products = ::Product.scoped( { :conditions => ["icecat_product_xml IS NOT NULL" ] } )
      products = products.scoped( { :conditions => { :image_file_name => nil } } )
      j = 1
      i = products.count
      say "importing images for #{i} products"
      
      products.all.each do |product|
        begin
          product.import_icecat_images
          say "Product save : #{product.save} : (#{j}/#{i})"
          j = j + 1
        rescue Exception => e
          say "Exception occured while importing images for product ##{product.id} (#{e})"
        end
      end
    end
    
    
    def product_full( product )
      unless product.is_a?( ::Product )
        product = ::Product.find( product )
      end
      
      product.import_icecat_xml
      if( product.valid? && product.save )
        begin
          product.import_icecat_images
          product.save
        rescue Exception => e
          say "Error importing images from icecat: #{e}"
        end
        
        begin
          product.import_related_products
          product.save
        rescue Exception => e
          say "Error importing related products from icecat: #{e}"
        end
        
        product.icecat_last_import = @import_timestamp
        product.save
        say "Icecat Data for Product #{product.id} saved"
      else
        say "Product Error: #{product.errors.full_messages}"
      end
      
    end
    
    
    
    def full
      products = ::Product.scoped( { :conditions => ["icecat_product_xml IS NOT NULL"] } )
      products = products.scoped( { :conditions => { :icecat_last_import => nil } } )
      j = 1
      i = products.count
      say "importing #{i} Products"

      products.all.each do |product|
        self.product_full( product )
        j = j + 1
      end
    end
    
    def daily
    end
    
    
    # 
    # 
    # def import_products
    #   i = Product.count
    #   j = 1
    #   puts "importing #{i} Products"
    #   Product.all.each do |product|
    #                 puts "importing product ##{product.id}.."
    #       product.article_number =~ /^HP-(.*)$/
    #       article_number = $1 || product.article_number
    # 
    #       product_xml_filename = @xml.find("//file[@Prod_ID='#{article_number}']").first
    #       puts "not found '#{article_number}'" unless product_xml_filename
    #       next unless product_xml_filename
    #       puts "filename #{product_xml_filename.attributes['path']}"
    #       product_xml = Icecat::Access.new.product_uri( "/" + product_xml_filename.attributes["path"] )
    #       puts "product_xml downloaded"
    # 
    #       product.import_icecat_xml( product_xml )
    #       if product.valid? && product.save
    #         puts "product ##{product.id} saved"
    #       else
    #         puts product.errors.to_s
    #       end
    # 
    # 
    #   end
    # end

  end
end



    
__END__
    
export/freexml.int/INT/1312163.xml
    class << self ;
      def run( process = :products, time = :full, debug = true )
        import = new( debug )
        import.send( :"#{process}_#{time}" )
      end
    end

    attr_accessor :xml_dir
    
    def initialize( debug = false, xml_dir = "." )
      @debug = debug
      @timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
      @import_start = Time.now
      @xml_dir = xml_dir
    end
    
    def verbose?
      !!@debug
    end
    
    
    def download_full_index
      full_index_file = File.join( RAILS_ROOT, "tmp", "icecat", "full.index.xml" )
      
      File.open( full_index_file, "w" ) do |f|
        f.puts Icecat::Url2Xml.new.full_index
      end
      
    end
    
    
    def download_xmls_full
      j = ::Product.count
      i = 1
      Product.all.each do |product|
        prod_id = product.article_number
        prod_id =~ /^HP\-(.+)$/
        prod_id = $1 if $1
        file = Icecat::Url2Xml.new.get( :prod_id => prod_id, :lang => 'int' )
        @xml_dir = File.join( RAILS_ROOT, "icecat_xmls", "full_#{@timestamp}")
        FileUtils.mkdir_p( @xml_dir )
        File.open( File.join( @xml_dir, "product_#{product.id}.xml" ), "w" ) do |f|
          f.puts file
        end
        puts "Saved xml #{i}/#{j}" if self.verbose?
        i = i + 1
      end
    end
    
    def download_xmls_daily
    end
    
    def products_pictures
      j = ::Product.count
      i = 1
      Product.all.each do |product|
        ip = Icecat::Product.new( product )
        ip.load_xml( File.join( @xml_dir, "product_#{product.id}.xml" ) )
        { :overview => "HighPic", :detail => "HighPic", :related => "HighPic" }.each_pair do |key, value|
          ip.picture( key, value )
        end
        puts "Imported picture for Product ##{product.id} : #{i}/#{j}" if self.verbose?
        i = i + 1
      end
    end
    
    
    def products_full( args = { :pictures => true } )
#      j = ::Product.since_icecat_import( nil ).count
      j = ::Product.count
      i = 1 
#      Product.since_icecat_import( nil ).each do |product|
      Product.all.each do |product|
        ip = Icecat::Product.new( product )
        ip.load_xml( File.join( @xml_dir, "product_#{product.id}.xml" ) )
        ip.import!
        ip.save
        if args[:pictures]
          { :overview => "LowPic", :detail => "HighPic", :related => "HighPic" }.each_pair do |key, value|
            ip.picture( key, value )
          end
        end
        product.icecat_last_import = @import_start
        product.save
        puts "Imported Data for Product ##{product.id} : #{i}/#{j}" if self.verbose?
        i = i + 1
      end
    end
    
    def products_daily
    end

  end
end
