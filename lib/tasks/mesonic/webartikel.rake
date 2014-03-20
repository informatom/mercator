# encoding: utf-8

namespace :webartikel do

  # starten als: 'bundle exec rake webartikel:import
  # in Produktivumgebungen: 'bundle exec rake webartikel:import RAILS_ENV=production'
  desc 'Import from Mesonic Webartikel view into inventories'
  task :import => :environment do
    Mesonic::Webartikel.import(update: "all")
  end

  # starten als: 'bundle exec rake webartikel:update
  # in Produktivumgebungen: 'bundle exec rake webartikel:update RAILS_ENV=production'
  desc 'Update from Mesonic Webartikel view into inventories'
  task :update => :environment do
    Mesonic::Webartikel.import(update: "changed")
  end
end