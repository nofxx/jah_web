# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_jah_session',
  :secret      => 'dd606d50350ced24c17f60d8243baafab2797b970909c8fd97c65a61487dcfb327f8eab4fcad1a2f4e93c6a76f647080cbdc8dbc2729ed1672203f59c4f96320'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
