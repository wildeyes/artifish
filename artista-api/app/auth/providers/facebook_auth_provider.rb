class FacebookAuthProvider < BaseAuthProvider
  def initialize(auth_code, redirect_uri)
    super
    @user_info_url = "https://graph.facebook.com/v3.0/me?fields=#{profile_fields}"
    @access_token_url = "https://graph.facebook.com/v3.0/oauth/access_token"
    @provider = :facebook
  end

  private

  def token_exchange_params
    {
      code: @auth_code,
      client_id: OAUTH_PROVIDERS[:facebook][:client_id],
      client_secret: OAUTH_PROVIDERS[:facebook][:client_secret],
      redirect_uri: @redirect_uri
    }
  end

  def profile_fields
    ['id', 'first_name', 'last_name', 'email'].join(',')
  end
end
