related_product_ids = @product_hash['ProductRelated'].collect { |s| s['Product']['ID'].to_i }

<ProductRelated ID="96789496" Category_ID="375" Reversed="0" Preferred="0">
  <Product ID="12360550" Prod_id="15069DK" ThumbPic="http://images.icecat.biz/thumbs/12360550.jpg"
          Name="Magenta Laser Toner - HP 503A (Q7583A) / Canon 711M (1658B002) - For HP Color LaserJet / Canon LBP & MF">
    <Supplier ID="7278" Name="MM"/>
  </Product>
</ProductRelated>

-> Zubehör  (andere icecat_category_id), sonst in ähnliche Produkte

def import_icecat_images
  if pic = @product_hash['HighPic']
    io = open( pic )
    pic_content = base_uri.path.split("/").last.blank? ? nil : io
    self.overview = pic_content
    self.image = pic_content
  end
end

p.icecat_last_import = Time.now

... könnte für Filter nützlich werden...
Category.all[47].products.*.values.flatten.flatten.*.property.uniq.*.id