# Add any oauth provider to this list
# The key will be the name of the routing /auth/:key
# and the name of the method in AuthenticationController with an action #{key}_oauth
# that will get an authorization code from the client and will perform a
# code-token exchange with the oauth server and will log you in

# Example:

OAUTH_PROVIDERS = {
  :google => { client_id: ENV['GOOGLE_CLIENT_ID'], client_secret: ENV['GOOGLE_CLIENT_SECRET'] },
  :facebook => { client_id: ENV['FACEBOOK_CLIENT_ID'], client_secret: ENV['FACEBOOK_CLIENT_SECRET'] },
}
