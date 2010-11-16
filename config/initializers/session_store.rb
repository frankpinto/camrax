# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
#ActionController::Base.session = {
#  :key         => '_camrax_session',
#  :secret      => 'b5ac7acb5b56647bcf39972fc420235b17ee3ea9ee9e9166c4bae1cd7a51b86dbe49c32eed9d9dc5663a77408f8d379d9116b43ed71052d5f0692e51bfd81b7b'
#}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
