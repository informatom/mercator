# encoding: utf-8

namespace :orders do

  # starten als: rake orders:cleanup_deprecated
  # in Produktivumgebungen: bundle exec rake orders:cleanup_deprecated RAILS_ENV=production
  desc "Cleanup deprecated orders"
  task :cleanup_deprecated => :environment do
    Order.cleanup_deprecated
  end
end