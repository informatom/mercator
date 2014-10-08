# encoding: utf-8

namespace :lineitems do

  # starten als: rake lineitems:cleanup_orphaned
  # in Produktivumgebungen: bundle exec rake lineitems:cleanup_orphaned RAILS_ENV=production
  desc "Cleanup orphaned lineitems"
  task :cleanup_orphaned => :environment do
    Lineitem.cleanup_orphaned
  end
end