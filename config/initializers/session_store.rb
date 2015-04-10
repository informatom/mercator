# Be sure to restart your server when you modify this file.

Mercator::Application.config.session_store :cookie_store, key: '_mercator_session', domain: :all, :expire_after => 2592000

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Mercator::Application.config.session_store :active_record_store
