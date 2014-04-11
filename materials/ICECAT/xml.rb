#require 'libxml'
require 'open-uri'

module Icecat::Product::Xml

  def icecat_vendor
    self.article_number =~ /^HP-(.+)$/
    $1 ? "1" : nil
  end

  def icecat_article_number
    self.article_number =~ /^HP-(.+)$/
    $1 || self.article_number
  end

  def import_icecat_related_products
    unless @icecat_hash
      return unless self.load_icecat_xml_to_hash
    end
    related_product_ids = @product_hash['ProductRelated'].collect { |s| s['Product']['ID'].to_i } rescue []
    self.related_product_ids = ::Product.find( :all, :conditions => { :icecat_product_id => related_product_ids } ).collect(&:id)
  end

  def import_icecat_option_products
    return nil if self.related_products.empty?

    option_products = self.related_products.select do |related|
      related.icecat_category_id.to_i != self.icecat_category_id.to_i
    end

    self.supply_ids = option_products.collect(&:id)
  end

  def import_icecat_images
    unless @icecat_hash
      self.load_icecat_xml_to_hash
    end

    begin
      if pic = @product_hash['HighPic']
        io = open( pic )
        def io.original_filename ; base_uri.path.split("/").last ; end
        pic_content = io.original_filename.blank? ? nil : io
        self.overview = pic_content
        self.image = pic_content
      end
    rescue
    end
  end

  def clear_icecat_hash
    @icecat_hash = nil
    @product_hash = nil
  end

  def load_icecat_xml_to_hash
    begin
      product_xml_io = Icecat::Access.new.product_uri( self.icecat_product_xml )
    rescue Exception => e
      puts "Error #{e}"
      return nil
    end

    @icecat_hash = Hash.from_xml( product_xml_io.read )
    @product_hash = @icecat_hash['ICECAT_interface']['Product']

    product_xml_io.close
    product_xml_io = nil
  end

  def convv(c)
    c #Iconv.iconv("ISO-8859-1","UTF-8",  c)
  end

  def import_icecat_xml
    unless @icecat_hash
      self.load_icecat_xml_to_hash
    end

    icecat_hash = @icecat_hash
    product_hash = @product_hash

    globalize = { :de => { :locale => 'de' }, :en => { :locale => 'en' } }

    if( de_globalize = self.globalize_translations.find_by_locale("de") )
      globalize[:de][:id] = de_globalize.id
    end
    if( de_globalize = self.globalize_translations.find_by_locale("en") )
      globalize[:en][:id] = de_globalize.id
    end

    globalize[:de][:title] = self.name
    globalize[:en][:title] = self.name

    tmp_hash = product_hash['Category']['Name'].select { |s| s['langid'] == '1' }
    unless tmp_hash.empty?
      globalize[:en][:icecat_category] = tmp_hash.first['Value']
    end

    tmp_hash = product_hash['Category']['Name'].select { |s| s['langid'] == '4' }
    unless tmp_hash.empty?
      globalize[:de][:icecat_category] = tmp_hash.first['Value']
    end

    tmp_arr = product_hash['ProductDescription']
    tmp_arr = [ tmp_arr ] unless tmp_arr.is_a?( Array )

    tmp_hash = tmp_arr.select { |s| s['langid'] == '1' }
    unless tmp_hash.empty?
      globalize[:en][:long_description] = tmp_hash.first["LongDesc"]
      globalize[:en][:short_description] = tmp_hash.first["ShortDesc"]
      globalize[:en][:warranty_info] = tmp_hash.first["WarrantyInfo"]
    end

    tmp_hash = tmp_arr.select { |s| s['langid'] == '4' }
    unless tmp_hash.empty?
      globalize[:de][:long_description] = tmp_hash.first["LongDesc"]
      globalize[:de][:short_description] = tmp_hash.first["ShortDesc"]
      globalize[:de][:warranty_info] = tmp_hash.first["WarrantyInfo"]
    end
    tmp_arr = nil

    self.globalize_translations_attributes = [ globalize[:de], globalize[:en] ]


    features = product_hash['ProductFeature']
    features = features.is_a?( Array ) ? features : [ features ]
    features.each do |f|
      presentation_value = f['Presentation_Value']
      feature_id = f['Feature']['ID']
      value = convv( f['Value'] )

      feature_group_id = f['CategoryFeatureGroup_ID']
      globalize_feature = [ [ 1, :en ], [4, :de ] ].collect do |loc|
        name = f['Feature']['Name'].select { |s| s['langid'] == loc.first.to_s }
        name = name.empty? ? "" : name.first['Value']

        group_arr = product_hash['CategoryFeatureGroup']
        group_arr = [ group_arr ] unless group_arr.is_a?( Array )

        group = group_arr.select { |s| s['ID'] == feature_group_id }
        group = group.empty? ? "" : group.first['FeatureGroup']['Name'].select { |s| s['langid'] == loc.first.to_s }
        group = group.empty? ? "" : group.first['Value']

        sign = f['Feature']['Measure']['Signs']['Sign'].last rescue ""
        sign = sign.empty? ? "" : sign

        { :locale => loc.last.to_s, :name => name, :group => group, :sign => sign }
      end

      feature_hash = {
        :value => value,
        :presentation_value => presentation_value,
        :icecat_feature_id => feature_id,
        :globalize_translations_attributes => globalize_feature
      }

      existing_property = ::Property.find_by_icecat_feature_id_and_value( feature_id, value )

      if existing_property.nil?
        self.properties.build( feature_hash )
      else
        existing_associated_property = self.properties.find_by_id( existing_property.id )
        if existing_associated_property.nil?
          self.properties << existing_property
        end
      end
      feature_hash = nil

    end

    product_hash = nil
    icecat_hash = nil
    tmp_hash = nil
    tmp_arr = nil
    return self
  end
end