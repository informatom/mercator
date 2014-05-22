# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mercator::Application.initialize!

# HAS: 20140327 I have to do this because of
# belongs_to :mesonic_kontakte_stamm, class_name: "MercatorMesonic::KontakteStamm", foreign_key: :erp_account_nr, primary_key: :mesoprim
# and three more relations like this in User. Hobo migration generator  wants to be clever and change the column to an Integer.
Generators::Hobo::Migration::Migrator.ignore_models = ["User"]