#orpahend records
Recommendation.where.not(product_id: Product.pluck("id"))

# find Instances without related Instances
Product.includes(:values).where( values: { product_id: nil } )
Inventory.includes(:prices).where(prices: {inventory_id: nil })

# Test url helpers in console:
include Rails.application.routes.url_helpers