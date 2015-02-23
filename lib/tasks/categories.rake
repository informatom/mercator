# encoding: utf-8
require 'faker'

namespace :categories do
  # starten als: 'bundle exec rake categories:fake[42] RAILS_ENV=production'
  desc "Create fake Categories"
  task :fake, [:count] => :environment do |t, args|

    Category.delete_all
    Category.create(name: Faker::Commerce.product_name, position: 1)

    args[:count].to_i.times do |i|
      pos = 1 + rand(i - 1).to_i
      parent = Category.find_by_position(pos)
      cat = Category.create(name: Faker::Commerce.product_name, parent_id: parent.id, position: (i + 2) )
    end
  end

  # starten als: 'bundle exec rake categories:deprecate RAILS_ENV=production'
  desc "Deprecates categories without active products in itself or in subcategories"
  task :deprecate => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: categories:deprecate")
    Category.deprecate
    JobLogger.info("Finished Job: categories:deprecate")
    JobLogger.info("=" * 50)
  end

  # starten als: 'bundle exec rake categories:reindex RAILS_ENV=production'
  desc "Reindexes Elasticsearch and rebuilds category property hashes."
  task :reindex => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: categories:reindex")
    Category.reindexing_and_filter_updates()
    JobLogger.info("Finished Job: categories:reindex")
    JobLogger.info("=" * 50)
  end

  # starten als: 'bundle exec rake categories:delete_childrenless RAILS_ENV=production'
  desc "Deletes childrenless categories"
  task :delete_childrenless => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: categories:delete_childrenless")
    Category.all.each do |category|
      if category.children.empty? && category.products.empty?
        JobLogger.info("Deleteting Catogory " + category.name)
        category.delete
      end
    end
    JobLogger.info("Finished Job: categories:delete_childrenless")
    JobLogger.info("=" * 50)
  end
end