def import_icecat_xml
  features.each do |f|
    presentation_value = f['Presentation_Value']
    feature_id = f['Feature']['ID']
    value = f['Value']

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
  end
end

def import_icecat_related_products
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
  if pic = @product_hash['HighPic']
    io = open( pic )
    def io.original_filename ; base_uri.path.split("/").last ; end
    pic_content = io.original_filename.blank? ? nil : io
    self.overview = pic_content
    self.image = pic_content
  end
end

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

p.icecat_last_import = Time.now