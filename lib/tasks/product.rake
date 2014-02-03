# encoding: utf-8
namespace :product do
  # starten als: 'bundle exec rake product:activateplus
  # in Produktivumgebungen: 'bundle exec rake product:activateplus RAILS_ENV=production'
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
end