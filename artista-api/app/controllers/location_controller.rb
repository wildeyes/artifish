class LocationController < ApplicationController
  skip_before_action :authorize_request

  def get_locale
    ip_address = request.remote_ip
    if ip_address == "127.0.0.1"
      ip_address = HTTParty.get('http://whatismyip.akamai.com').body
    end
    url = "http://api.ipstack.com/#{ip_address}?access_key=#{ENV['IPSTACK_API_KEY']}&fields=country_code"
    response = HTTParty.get(url)
    json = JSON.parse(response.body)
    if json['country_code'] == "IL"
      json_response({locale: :he})
    else
      json_response({locale: :en})
    end
  end
end
