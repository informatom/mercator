# encoding: utf-8
namespace :property_groups do
  # starten als: 'bundle exec rake property_groups:dedup
  # in Produktivumgebungen: 'bundle exec rake property_groups:dedup RAILS_ENV=production'
  desc "Deduplicating property groups and removing orphans"
  task :dedup => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: property_groups:dedup")

    PropertyGroup.dedup()

    JobLogger.info("Finished Job: property_groups:dedup")
    JobLogger.info("=" * 50)
  end

  # starten als: 'bundle exec rake property_groups:fix_position
  # in Produktivumgebungen: 'bundle exec rake property_groups:fix_position RAILS_ENV=production'
  desc "Fixing the order of property_groups"
  task :fix_position => :environment do
    JobLogger.info("=" * 50)
    JobLogger.info("Started Job: property_groups:fix_position")

    PropertyGroup.order(:position).each_with_index do |property_group, index|
      property_group.update(position: index + 1 )
    end

    JobLogger.info("Finished Job: property_groups:fix_position")
    JobLogger.info("=" * 50)
  end
end