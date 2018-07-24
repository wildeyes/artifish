class LinkedImagesController < ApplicationController
  skip_before_action :authorize_request

  def external_search
    @images = []
    keywords = params[:keywords].gsub(' ', '+')
    rootUrl = "https://society6.com"
    urls = [
      "#{rootUrl}/s?q=#{keywords}+wall-art",
      # "#{rootUrl}/s?q=#{keywords}+prints"
    ]
    urls.each do |url|
      response = HTTParty.get(url)
      # TODO: Add categories / tags (for ex: wall-art / prints etc)
      page = Nokogiri::HTML(response.body)
      div_cards = page.xpath("//*[@*[contains(., 'card_product_')]]")
      @images += div_cards.map do |div_card|
        div_img = div_card.xpath(".//*[@*[contains(., 'image_product_')]]").first
        div_meta = div_card.xpath(".//*[@*[contains(., 'meta_product_')]]").first
        div_price = div_meta.xpath(".//*[@*[contains(., 'price_product_')]]").first
        img_json = JSON.parse div_img.css('script').text
        {
          url_link: rootUrl + div_img.css('a').first['href'],
          image_link: img_json['image'],
          name: img_json['name'],
          price: div_price.css('span').first.text.gsub('$', '')
        }
      end
    end
    @images.uniq! {|i| i[:url_link]}
    @images.map! {|i| i.deep_transform_keys! { |key| key.to_s.camelize(:lower) }}
    json_response(@images)
  end
end
