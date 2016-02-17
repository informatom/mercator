#orpahend records
Recommendation.where.not(product_id: Product.pluck("id"))
Value.where.not(product_id: Product.pluck("id"))

# find Instances without related Instances
Product.includes(:values).where( values: { product_id: nil } )
Inventory.includes(:prices).where(prices: {inventory_id: nil })

Category.find(3444).products.active.includes(:inventories).where(inventories: {product_id: nil }).*.id

# Test url helpers in console:
include Rails.application.routes.url_helpers

# Delete old logentries
Logentry.where("created_at<?", 2.month.ago).count
Logentry.where("created_at<?", 2.month.ago).delete_all


# Delete old versions
PaperTrail::Version.where("created_at<?", 2.month.ago).count
PaperTrail::Version.where("created_at<?", 2.month.ago).delete_all

# Products without values
Product.includes(:values).where( values: { product_id: nil } ).count
# Import icecat values for products without any
Product.includes(:values).where( values: { product_id: nil } ).*.update_from_icecat(from_today: false, initial_import: false)
