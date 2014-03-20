# encoding: utf-8

namespace :inventory do

  # starten als: 'bundle exec rake inventory:delivery_time
  # in Produktivumgebungen: 'bundle exec rake inventory:delivery_time RAILS_ENV=production'
  desc "Creates dummy delivery_time"
  task :delivery_time => :environment do
    Inventory.all.each do |inventory|
      @delivery_time = Constant.where(key: 'delivery_times_de').first.value.split(',')[Random.rand(4)]
      inventory.update_attributes(delivery_time: @delivery_time)
    end
  end
end