# encoding: utf-8
require 'faker'
require 'require_all'
$stdout.sync = true

namespace :import do
  # starten als: 'bundle exec rake import:legacy
  # in Produktivumgebungen: 'bundle exec rake import:legacy RAILS_ENV=production'
  desc "Import from legacy webshop"
  task :legacy => :environment do

  require_rel "import"
  # import_users()
  # import_countries()
  # import_products()
  # import_categories()
  import_categorizations()

  puts
  end
end