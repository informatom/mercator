MesonicJob.new( :mirror_webartikel ).perform

webartikel = Inventory.find( :all )
missing_webartikel = webartikel.select { |s| s.product.nil? }

missing_webartikel.each do |inventory|
  inventory.create_corresponding_product!
end