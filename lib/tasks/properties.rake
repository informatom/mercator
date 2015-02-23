# encoding: utf-8
namespace :properties do
  # starten als: bundle exec rake properties:dedup RAILS_ENV=production
  desc "deduplicating properties and removing orphans"
  task :dedup => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: properties:dedup")

    Properties.dedup()

    JobLogger.info("Finished Job: properties:dedup")
    JobLogger.info("=" * 50)
  end

  # starten als: bundle exec rake properties:fix_position RAILS_ENV=production
  desc "Fixing the order of properties"
  task :fix_position => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: properties:fix_position")

    Property.order(:position).each_with_index do |property, index|
      property.update(position: index + 1 )
    end

    JobLogger.info("Finished Job: properties:fix_position")
    JobLogger.info("=" * 50)
  end
end
