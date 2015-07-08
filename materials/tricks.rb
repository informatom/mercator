#orpahend records
Recommendation.where.not(product_id: Product.pluck("id"))

# find Instances without related Instances
Product.includes(:values).where( :values => { :product_id => nil } )