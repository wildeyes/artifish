class GoogleAuthProvider < BaseAuthProvider
  def initialize(auth_code, redirect_uri)
    super
    @user_info_url = "https://www.googleapis.com/oauth2/v2/userinfo"
    @access_token_url = "https://www.googleapis.com/oauth2/v4/token"
    @provider = :google
  end

  private

  def token_exchange_params
    {
      code: @auth_code,
      client_id: OAUTH_PROVIDERS[:google][:client_id],
      client_secret: OAUTH_PROVIDERS[:google][:client_secret],
      redirect_uri: @redirect_uri,
      grant_type: 'authorization_code'
    }
  end

  def fields_mapping
    @fields_mapping ||= {
      first_name: 'given_name',
      last_name: 'family_name'
    }
  end
end
