# Hadean::Application.config.session_store :cookie_store, :key => '_ror_ecommerce_session_pIUHGFhsgbhsvgfshbdhgh456jb3hhy387u'
Rails.application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 5.hours
#
#  it is also recommended to change the cache store in config/environments/*.rb
#   config.cache_store = :dalli_store


# Be sure to restart your server when you modify this file.

#


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# Hadean::Application.config.session_store :active_record_store
