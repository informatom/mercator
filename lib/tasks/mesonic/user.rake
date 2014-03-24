# encoding: utf-8

namespace :mesonic do
  namespace :accounts do

    # starten als: 'bundle exec rake mesonic:accounts:import'
    # in Produktivumgebungen: 'bundle exec rake mesonic:accounts:import RAILS_ENV=production'
    desc 'Import from Mesonic Accounts into users and addresses'
    task :import => :environment do
      Mesonic::Account.import
    end
  end
end