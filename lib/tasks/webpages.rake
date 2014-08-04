# encoding: utf-8

namespace :webpages do
  # starten als: 'bundle exec rake webpages:generate_slugs'
  # in Produktivumgebungen: 'bundle exec rake webpages:generate_slugs RAILS_ENV=production'
  desc "Create Slugs for Webpages"
  task :generate_slugs => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: categories:generate_slugs")

    Webpage.all.each do |webpage|
      webpage.slug = nil
      webpage.save
    end

    JobLogger.info("Finished Job: categories:generate_slugs")
    JobLogger.info("=" * 50)
  end
end