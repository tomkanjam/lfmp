# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_lfmp_session',
  :secret      => '6b497845b6594d336a94ae7df0f7461c6625336cf5211b33a37094ead1cecce7311012b56b54b85b71da2f6b045d458eb669cdd57d31bdee989701964fd6386c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
