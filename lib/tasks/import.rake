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
#  import_users()
#  import_countries()
#  import_categories()
#  import_products()
#  import_properties()
#  import_features()
#  import_categorizations()
#  import_product_images()
#  import_product_relations()
#  import_supply_relations()
#  import_recommendations()
#  import_page_templates()
#  import_pages()
#  import_content_elements()
#  import_category_images()
#  import_cms_node_images()
#  import_unlinked_content_items()
#  import_remaining_images()
#  import_remaining_assets()
  puts
  end
end