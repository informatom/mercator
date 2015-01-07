require File.expand_path('../application', __FILE__)

Mercator::Application.initialize!

Generators::Hobo::Migration::Migrator.ignore_tables = [
  "friendly_id_slugs",
  "mercator_icecat_metadata",
  "taggings",
  "tags"
]