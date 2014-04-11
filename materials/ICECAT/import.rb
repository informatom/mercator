require 'icecat/url2xml'
module Icecat

  class Import

    # --- Class Methods --- #

    def self.products( t = :full, file = nil )
      i = new
      i.set_xml( file ) if t == :daily
      i.send( t )
    end

    # --- Instance Methods --- #

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
  end
end

__END__
export/freexml.int/INT/1312163.xml