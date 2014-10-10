# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_arhibas_session',
  :secret      => '0b8946a698a13c7c9ce777589fc37e129e33f15c206cc25fbb49311e901053c2b04cdc9abd2db41c2690e4fefd46afdaf14d902536601c0180422726458aeeb9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
