# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mercator::Application.initialize!

# HAS: 20140830
Generators::Hobo::Migration::Migrator.ignore_tables = ["friendly_id_slugs", "mercator_icecat_metadata"]