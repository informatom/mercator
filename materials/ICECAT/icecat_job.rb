class IcecatJob

  attr_accessor :runner_method

  class << self ;
    def xml_index_filename
      if RAILS_ENV.to_sym == :production
        File.join( RAILS_ROOT, "..", "..", "shared", "icecat", "full.index.xml" )
      else
        File.join( RAILS_ROOT, "tmp", "icecat", "full.index.xml" )
      end
    end

    def xml_daily_filename
      if RAILS_ENV.to_sym == :production
        File.join( RAILS_ROOT, "..", "..", "shared", "icecat", "daily.index.xml" )
      else
        File.join( RAILS_ROOT, "tmp", "icecat", "daily.index.xml" )
      end
    end
  end

  def initialize( method_name, options = {} )
    @runner_method = method_name
    @index_file = options[:index_file] || self.class.xml_index_filename
    @products_scope = options[:products_scope] || {}
    @product_id = options[:product_id] || nil
  end

  def perform
    if @runner_method == :all
      import_meta_data
      update_product_meta_data
      import_icecat_xml_full
    else
      self.send( @runner_method ) if self.respond_to?( @runner_method )
    end
  end

  protected

  def import_icecat_xml_for_product
    return true unless @product_id
    p = ::Product.find( @product_id )
    return true unless p

    if imd = IcecatMetaData.find_by_prod_id( p.icecat_article_number )
      p.icecat_product_xml = imd.path
      p.icecat_product_id  = imd.product_id
      p.icecat_category_id = imd.cat_id
    else
      return false
    end

    begin
      p.import_icecat_xml
      p.import_icecat_related_products
      p.import_icecat_option_products
      p.import_icecat_images
      p.icecat_last_import = Time.now
      p.save
      p.clear_icecat_hash
    rescue => error
    end

    p = nil
    true
  end

  def import_icecat_xml_full

    for_each_product({:conditions => ["icecat_last_import IS NULL AND icecat_product_xml IS NULL"] } ) do |product|
      if imd = IcecatMetaData.find_by_prod_id( product.icecat_article_number )
        product.icecat_product_xml = imd.path
        product.icecat_product_id  = imd.product_id
        product.icecat_category_id = imd.cat_id
      end
      imd = nil
    end

    for_each_product { |product|
      if RAILS_ENV.to_sym == :development
        puts "-----" * 100
        puts product.id
        puts "-----" * 100
      end

      product.import_icecat_xml
      product.import_icecat_related_products
      product.import_icecat_option_products
      product.import_icecat_images
      product.icecat_last_import = Time.now
      product.clear_icecat_hash

    }
  end

  def scoped_products
    Product.scoped( @products_scope )
  end


  def for_each_product( scope = { :conditions => ['icecat_last_import IS NULL AND icecat_product_xml IS NOT NULL'] }, &block)
    each_product_scope = scoped_products.scoped( scope )
    count = each_product_scope.count
    i = 1
    each_product_scope.all.each do |product|
      block.call(product)
      product.save
      product.clear_icecat_hash
      i += 1
    end
    each_product_scope = nil
    true
  end


  def import_icecat_xml
    for_each_product { |product| product.import_icecat_xml }
  end


  def import_icecat_related_products
    for_each_product { |product| product.import_related_products }
  end


  def import_icecat_images
    for_each_product { |product| product.import_icecat_images }
  end

  def import_icecat_option_products
    for_each_product { |product| product.import_options }
  end

  def import_icecat_meta_data
    for_each_product(@products_scope || {}) { |product|
      if imd = IcecatMetaData.find_by_prod_id( product.icecat_article_number )
        product.icecat_product_xml = imd.path
        product.icecat_product_id  = imd.product_id
        product.icecat_category_id = imd.cat_id
      end
    }
  end

  def import_meta_data
#    IcecatMetaData.delete_all
    File.open( self.class.xml_index_filename ) do |f|
      f.each_line do |line|
        if line.include?("Supplier_id=\"1\"")
          hash = Hash.from_xml( line.gsub(/\s\>$/, "/>") )
          hash = hash['file']
          next if IcecatMetaData.find_by_product_id( hash['Product_ID'] )
          imd = IcecatMetaData.new
          imd.path = hash['path']
          imd.cat_id = hash['Catid']
          imd.product_id = hash['Product_ID']
          imd.icecat_updated_at = hash['Updated']
          imd.quality = hash['Quality']
          imd.supplier_id = hash['Supplier_id']
          imd.prod_id = hash['Prod_ID']
          imd.on_market = hash['On_Market']
          imd.model_name = hash['Model_Name']
          imd.product_view = hash['Product_View']
          imd.save
        end
      end
    end
  end

  def import_daily_meta_data
    File.open( self.class.xml_daily_filename ) do |f|
      f.each_line do |line|
        if line.include?("Supplier_id=\"1\"")
          hash = Hash.from_xml( line.gsub(/"\>$/, "\"/>").gsub(/\s\>/, "/>") )
          hash = hash['file']
          imd = IcecatMetaData.find_by_product_id( hash['Product_ID'] )
          imd = IcecatMetaData.new if imd.nil?
          imd.path = hash['path']
          imd.cat_id = hash['Catid']
          imd.product_id = hash['Product_ID']
          imd.icecat_updated_at = hash['Updated']
          imd.quality = hash['Quality']
          imd.supplier_id = hash['Supplier_id']
          imd.prod_id = hash['Prod_ID']
          imd.on_market = hash['On_Market']
          imd.model_name = hash['Model_Name']
          imd.product_view = hash['Product_View']
          imd.save
        end
      end
    end
  end

  def download_daily( filename )
    File.open( filename, "w" ) do |f|
      f.puts Icecat::Access.new.daily_index.read
    end
    filename
  end

  def download_index( filename )
    File.open( filename, "w" ) do |f|
      f.puts Icecat::Access.new.full_index.read
    end
    filename
  end
end