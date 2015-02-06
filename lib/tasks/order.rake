# encoding: utf-8

namespace :orders do

  # starten als: bundle exec rake orders:cleanup_deprecated RAILS_ENV=production
  desc "Cleanup deprecated orders"
  task :cleanup_deprecated => :environment do
    Order.cleanup_deprecated
  end

  # starten als: bundle exec rake orders:notify_in_payment RAILS_ENV=production
  desc "Notify via e-mail about orders stuck in payment"
  task :notify_in_payment => :environment do
    Order.notify_in_payment
  end
end