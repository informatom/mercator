def import_supply_relations
  puts "\n\nSupplyRelations:"

  Legacy::ProductSupply.all.each do |legacy_product_supply|
    if product = Product.find_by(legacy_id: legacy_product_supply.product_id)
      if supply = Product.find_by(legacy_id: legacy_product_supply.supply_id)

        if supplyrelation = Supplyrelation.create(product_id: product.id, 
                                                  supply_id: supply.id)
          print "S"
        else
          puts "\nFAILURE: Supplyrelation: " + supplyrelation.errors.first.to_s
        end
      else 
        puts "\n FAIILURE: Product not found"
      end
    else
        puts "\n FAIILURE: Supply not found"
    end
  end
end