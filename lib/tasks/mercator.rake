# encoding: utf-8

namespace :mercator do
  # starten als: bundle exec rake mercator:delete_inactive_and_history RAILS_ENV=production
  desc "Delete inactive products, users and version history"
  task :delete_inactive_and_history => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: mercator:delete_inactive_and_history")

    inactive_users = User.where.not(state: "active")
    JobLogger.info("Deleting " + inactive_users.count.to_s + " inactive users")
    inactive_users.delete_all

    inactive_products = Product.where.not(state: "active")
    JobLogger.info("Deleting " + inactive_products.count.to_s + " inactive products")
    inactive_products.delete_all

    version_entries = PaperTrail::Version.all
    JobLogger.info("Deleting " + version_entries.count.to_s + " version entries")
    version_entries.delete_all

    JobLogger.info("Finished Job: mercator:delete_inactive_and_history")
    JobLogger.info("=" * 50)
  end

  # starten als: bundle exec rake mercator:delete_orphans RAILS_ENV=production
  desc "Cleanup orphaned relations mercator"
  task :delete_orphans => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: mercator:delete_orphans")

    Address.all.each do |address|
      unless address.user
        JobLogger.info("Deleting address: " + address.id.to_s)
        address.delete
      end
    end
    JobLogger.info("Done with addresses")

    BillingAddress.all.each do |billing_address|
      unless billing_address.user
        JobLogger.info("Deleting billing address: " + billing_address.id.to_s)
        billing_address.delete
      end
    end
    JobLogger.info("Done with billing addresses")

    Categorization.all.each do |categorization|
      unless categorization.product && categorization.category
        JobLogger.info("Deleting categorization: " + categorization.id.to_s)
        categorization.delete
      end
    end
    JobLogger.info("Done with categorizations")

    Feature.all.each do |feature|
      unless feature.product
        JobLogger.info("Deleting feature: " + feature.id.to_s)
        feature.delete
      end
    end
    JobLogger.info("Done with features")

    unused = MercatorIcecat::Metadatum.where(product_id: nil)
    JobLogger.info("Deleting " + unused.count.to_s + " unused metadata")
    unused.delete_all

    MercatorIcecat::Metadatum.all.each do |metadatum|
      unless metadatum.product
        JobLogger.info("Deleting metadatum: " + metadatum.id.to_s)
        metadatum.delete
      end
    end
    JobLogger.info("Done with metadata")

    Inventory.all.each do |inventory|
      unless inventory.product
        JobLogger.info("Deleting inventory: " + inventory.id.to_s)
        inventory.delete
      end
    end
    JobLogger.info("Done with inventories")

    Price.all.each do |price|
      unless price.inventory
        JobLogger.info("Deleting price: " + price.id.to_s)
        price.delete
      end
    end
    JobLogger.info("Done with prices")

    Recommendation.all.each do |recommendation|
      unless recommendation.product && recommendation.recommended_product
        JobLogger.info("Deleting recommendation: " + recommendation.id.to_s)
        recommendation.delete
      end
    end
    JobLogger.info("Done with recommendations")

    Supplyrelation.all.each do |supplyrelation|
      unless supplyrelation.product && supplyrelation.supply
        JobLogger.info("Deleting supplyrelation: " + supplyrelation.id.to_s)
        supplyrelation.delete
      end
    end
    JobLogger.info("Done with supplyrelations")

    Value.all.each do |value|
      unless value.product && value.property && value.property_group
        JobLogger.info("Deleting value: " + value.id.to_s)
        value.delete
      end
    end
    JobLogger.info("Done with values")

    JobLogger.info("Finished Job: mercator:delete_orphans")
    JobLogger.info("=" * 50)
  end
end