#orpahend records
Recommendation.where.not(product_id: Product.pluck("id"))

# find Instances without related Instances
Product.includes(:values).where( values: { product_id: nil } )
Inventory.includes(:prices).where(prices: {inventory_id: nil })

Category.find(3444).products.active.includes(:inventories).where(inventories: {product_id: nil }).*.id

# Test url helpers in console:
include Rails.application.routes.url_helpers