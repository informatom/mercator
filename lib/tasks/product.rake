# encoding: utf-8
namespace :products do
  # starten als: 'bundle exec rake products:activateplus
  # in Produktivumgebungen: 'bundle exec rake products:activateplus RAILS_ENV=production'
  desc "Creates dummy prices, inventories and activates products"
  task :activateplus => :environment do
    Product.all.each do |product|
      @admin = User.where(administrator:true).first
      if product.lifecycle.can_activate?(@admin)
        product.lifecycle.activate!(@admin)
      end

      @inventory = product.inventories.create(name_de: product.name_de,
                                              number:  product.number,
                                              amount:  100,
                                              unit:    "Stk.")
      unless @inventory
        puts "\nFAILURE: Inventory " + inventory.name_de.to_s + " not created."
        next
      end

      @price = @inventory.prices.create(value:      (1 + Random.rand(1000)),
                                        vat:        20,
                                        valid_from: "2000-01-01",
                                        valid_to:   "2099-12-31",
                                        scale_from: 1,
                                        scale_to:   9999)
      unless @price
        puts "\nFAILURE: Price " + price.value.to_s + " not created."
        next
      end
    end
  end

  # starten als: 'bundle exec rake products:deprecate
  # in Produktivumgebungen: 'bundle exec rake products:deprecate RAILS_ENV=production'
  desc "Deprecates products without inventories"
  task :deprecate => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: products:deprecate")

    Product.deprecate

    JobLogger.info("Finished Job: products:deprecate")
    JobLogger.info("=" * 50)
  end

  # starten als: 'bundle exec rake products:fix_photo_content_type
  # in Produktivumgebungen: 'bundle exec rake products:fix_photo_content_type RAILS_ENV=production'
  desc "Fixes photo content types"
  task :fix_photo_content_type => :environment do
    Product.all.each do |product|
      if product.photo_content_type && product.photo_content_type.include?("text")
        extension = product.photo_file_name.split(".").last
        case extension
          when "jpg"
            product.update(photo_content_type: "image/jpeg")
            print "j"
          when "JPG"
            product.update(photo_content_type: "image/jpeg")
            print "j"
          when "png"
            product.update(photo_content_type: "image/png")
            print "p"
          when "gif"
            product.update(photo_content_type: "image/gif")
            print "g"
          else
            puts "No handler for " + extension + " declared. Fix this!"
        end
      end

      if product.photo_content_type && product.photo_content_type.include?("jpg")
        product.update(photo_content_type: "image/jpeg")
        print "*"
      end
    end
  end

  # starten als: 'bundle exec rake products:reindex
  # in Produktivumgebungen: 'bundle exec rake products:reindex RAILS_ENV=production'
  desc "Reindexes products in Elasticsearch."
  task :reindex => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: products:reindex")
    Product.reindex
    JobLogger.info("Finished Job: products:reindex")
    JobLogger.info("=" * 50)
  end
end
